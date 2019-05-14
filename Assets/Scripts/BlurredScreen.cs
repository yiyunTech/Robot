using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class BlurredScreen : MonoBehaviour
{

    public Shader curShader;

    System.Random CurRand;

    VideoPlayer _videoPlayer;

    float _curTime = 0.0f;
    public float displayTime = 3.0f;
    float _durationTime = 0.0f;
    public float waitTime = 3.0f;
    public bool _isDisplay = false;

    public int CurVideo = 0;
    public List<VideoClip> AllVideoCilps;
    public float[] Threshold;


    private Material curMaterial;
    float _totalAlpha = 0.0f;


    public int TestTag = 0;

    #region Properties
    public Material material
    {
        get
        {
            if (curMaterial == null)
            {
                _videoPlayer = GetComponent<VideoPlayer>();

                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;

                //curMaterial.mainTexture = _videoPlayer.texture;
                Texture tex = _videoPlayer.texture;
                curMaterial.SetTexture("_VideoTex", tex);
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



    void _videoPlay()
    {
        _isDisplay = true;

        _durationTime = 0.0f;

        CurVideo = CurRand.Next(0, 3);

        //CurVideo = 0;

        _videoPlayer.clip = AllVideoCilps[CurVideo];

        _videoPlayer.Play();
        _totalAlpha = 1.0f;

        material.SetFloat("_Threshold", Threshold[CurVideo]);
        material.SetInt("_CaseIdx", CurVideo);

    }

    void _videoStop()
    {
        material.SetInt("_CaseIdx", 10);

        _isDisplay = false;
        _durationTime = 0.0f;

        _videoPlayer.Stop();
        _totalAlpha = 0.0f;
    }

    void _updateVideoState()
    {
        _durationTime += Time.deltaTime;

        if (_isDisplay)
        {
            if (_durationTime > displayTime)
            {
                _videoStop();
            }
        }
        else
        {
            if (_durationTime > waitTime)
            {
                _videoPlay();
            }
        }


        
    }

    // Use this for initialization
    void Start()
    {
        CurRand = new System.Random();

        //_videoPlayer = this.GetComponent<VideoPlayer>();
        //_videoPlayer[CurVideo].Play();

    }

    

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {

        _updateVideoState();

       

        if (curShader)
        {
            TestTag = 1;
        
            // noise
            _verticalJumpTime += Time.deltaTime * _verticalJump * 11.3f;

            var sl_thresh = Mathf.Clamp01(1.0f - _scanLineJitter * 1.2f);
            var sl_disp = 0.002f + Mathf.Pow(_scanLineJitter, 3) * 0.05f;
            material.SetVector("_ScanLineJitter", new Vector2(sl_disp, sl_thresh));

            var vj = new Vector2(_verticalJump, _verticalJumpTime);
            material.SetVector("_VerticalJump", vj);

            material.SetFloat("_HorizontalShake", _horizontalShake * 0.2f);

            var cd = new Vector2(_colorDrift * 0.04f, Time.time * 606.11f);
            material.SetVector("_ColorDrift", cd);



            float CurOffset1 = 0f;
            float CurOffset2 = 0f;
            CurOffset1 = (float)CurRand.NextDouble();
            CurOffset2 = (float)CurRand.NextDouble();
            material.SetFloat("_SnowOffsetx", CurOffset1);
            material.SetFloat("_SnowOffsety", CurOffset2);
            material.SetFloat("_TotalAlpha", _totalAlpha);

            Texture tex = _videoPlayer.texture;
            material.SetTexture("_VideoTex", tex);

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
        

    }
}
