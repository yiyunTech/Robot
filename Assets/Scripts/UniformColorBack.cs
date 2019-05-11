
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//using DG.Tweening;


[ExecuteInEditMode]
public class UniformColorBack : MonoBehaviour
{
    #region Variables
    public Shader curShader;
    public float grayScaleAmount = 1.0f;
    public float contrastRatio = 1.0f;
    public Vector3 ConsistentColor = new Vector3(1.0f, 1.0f, 1.0f);
    public float Lumin = 1.0f;
    private Material curMaterial;
    #endregion

    #region Properties
    public Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }
    #endregion


    public bool UseNoise = true;

    [SerializeField, Range(0, 1)]
    float _scanLineJitter = 1;

    public float scanLineJitter
    {
        get { return _scanLineJitter; }
        set { _scanLineJitter = value; }
    }

    [SerializeField, Range(0, 1)]
    float _verticalJump = 1;

    public float verticalJump
    {
        get { return _verticalJump; }
        set { _verticalJump = value; }
    }

    [SerializeField, Range(0, 1)]
    float _horizontalShake = 0;

    public float horizontalShake
    {
        get { return _horizontalShake; }
        set { _horizontalShake = value; }
    }

    [SerializeField, Range(0, 1)]
    float _colorDrift = 1f;

    public float colorDrift
    {
        get { return _colorDrift; }
        set { _colorDrift = value; }
    }
    float _verticalJumpTime;

    //private void Awake()
    //{
    //    DOTween.To(() => _scanLineJitter, x => _scanLineJitter = x, 1f, 0.6f).SetLoops(-1, LoopType.Yoyo);
    //    DOTween.To(() => _colorDrift, x => _colorDrift = x, 0.1f, 1f).SetLoops(-1, LoopType.Yoyo);
    //}



    void Start()
    {
        if (SystemInfo.supportsImageEffects == false)
        {
            enabled = false;
            return;
        }

        if (curShader != null && curShader.isSupported == false)
        {
            enabled = false;
        }

        //ConsistentColor = new Vector3(1.0f, 1.0f, 1.0f);
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (curShader != null)
        {
            // noise
            if (UseNoise)
            {
                _verticalJumpTime += Time.deltaTime * _verticalJump * 11.3f;

                var sl_thresh = Mathf.Clamp01(1.0f - _scanLineJitter * 1.2f);
                var sl_disp = 0.002f + Mathf.Pow(_scanLineJitter, 3) * 0.05f;
                material.SetVector("_ScanLineJitter", new Vector2(sl_disp, sl_thresh));

                var vj = new Vector2(_verticalJump, _verticalJumpTime);
                material.SetVector("_VerticalJump", vj);

                material.SetFloat("_HorizontalShake", _horizontalShake * 0.2f);

                var cd = new Vector2(_colorDrift * 0.04f, Time.time * 606.11f);
                material.SetVector("_ColorDrift", cd);


                material.SetInt("_UseNoise", 1);
            }
            else
            {
                material.SetInt("_UseNoise", 0);
            }



            // uniform color

            material.SetFloat("_LuminosityAmount", grayScaleAmount);
            material.SetFloat("_Luminance", Lumin);
            material.SetFloat("_ContrastRatio", contrastRatio);


            material.SetFloat("_ConsistentColorR", ConsistentColor.x);
            material.SetFloat("_ConsistentColorG", ConsistentColor.y);
            material.SetFloat("_ConsistentColorB", ConsistentColor.z);

            Graphics.Blit(sourceTexture, destTexture, material);




        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    // Update is called once per frame
    void Update()
    {
        grayScaleAmount = Mathf.Clamp(grayScaleAmount, 0.0f, 1.0f);
    }

    void OnDisable()
    {
        if (curMaterial != null)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
