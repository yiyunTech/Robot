using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SignalNoise : MonoBehaviour {

    private Material curMaterial;
    public Shader curShader;

    public float minNoiseTime = 0.3f;
    public float maxNoiseTime = 3.0f;
    public float minWaitTime = 2.0f;
    public float maxWaitTime = 5.0f;
    
    bool _isUseNoise = false;
    float _durationTime = 0.0f;
    float _noiseTime = 0.0f;
    float _waitTime = 0.0f;

    System.Random CurRand;

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




    // 
    void _NoSignalStart()
    {
        _isUseNoise = true;
        _durationTime = 0.0f;
        material.SetInt("_UseNoise", 1);

        float cur_rand = (float)CurRand.NextDouble();
        cur_rand = cur_rand * cur_rand;
        _noiseTime = cur_rand * (maxNoiseTime - minNoiseTime) + minNoiseTime;
    }

    void _NoSignalEnd()
    {
        _isUseNoise = false;
        _durationTime = 0.0f;
        material.SetInt("_UseNoise", 0);

        float cur_rand = (float)CurRand.NextDouble();
        //cur_rand = cur_rand * cur_rand * cur_rand;
        _waitTime = cur_rand * (maxWaitTime - minWaitTime) + minWaitTime;
    }

    void _updateNoiseState()
    {
        _durationTime += Time.deltaTime;

        if (_isUseNoise)
        {
            if (_durationTime > _noiseTime)
            {
                _NoSignalEnd();
            }
        }
        else
        {
            if (_durationTime > _waitTime)
            {
                _NoSignalStart();
            }
        }
    }



    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {

        _updateNoiseState();

        if (curShader != null && _isUseNoise)
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


            


            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    // Use this for initialization
    void Start () {
        CurRand = new System.Random();

        _NoSignalEnd();
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    void OnDisable()
    {
        if (curMaterial != null)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
