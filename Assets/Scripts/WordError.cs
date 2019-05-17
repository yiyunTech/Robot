using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class WordError : MonoBehaviour
{

    public Shader curShader;
    VideoPlayer _videoPlayer;
    public VideoClip video;



    [SerializeField, Range(0, 1)]
    public float Threshold;

    [SerializeField, Range(0, 10)]
    public float WordWeight;

    public Color WordColor;

    private Material curMaterial;
    float _totalAlpha = 0.0f;


    System.Random CurRand;
    float _curTime = 0.0f;
    //public float minDisplayTime = 3.0f;
    //public float maxDisplayTime = 5.0f;
    public float displayTime = 4.0f;
    float _durationTime = 0.0f;
    public float minWaitTime = 8.0f;
    public float maxWaitTime = 12.0f;
    float waitTime = 0.0f;
    public bool _isDisplay = false;


    public int TestTag = 0;

    #region Properties
    public Material material
    {
        get
        {
            if (curMaterial == null)
            {
                
                

                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;

                //curMaterial.mainTexture = _videoPlayer.texture;
                //Texture tex = _videoPlayer.texture;
                //curMaterial.SetTexture("_VideoTex", tex);
            }
            return curMaterial;
        }
    }
    #endregion


    void _videoPlay()
    {
        _isDisplay = true;

        _durationTime = 0.0f;

        //CurVideo = 2;

       
        _videoPlayer.Play();
       

    }

    void _videoStop()
    {
        _isDisplay = false;
        _durationTime = 0.0f;
        waitTime = (float)CurRand.NextDouble() * (maxWaitTime - minWaitTime) + minWaitTime;

        _videoPlayer.Stop();
       
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

        _videoPlayer = GetComponents<VideoPlayer>()[1];
        _videoPlayer.clip = video;

        //_videoPlayer = this.GetComponent<VideoPlayer>();
        //_videoPlayer.Play();
        _videoPlay();

    }



    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        _updateVideoState();
        
        if (curShader)
        {
            TestTag = 1;

           





            Texture tex = _videoPlayer.texture;
            material.SetTexture("_VideoTex", tex);
            material.SetFloat("_Threshold", Threshold);
            material.SetFloat("_Weight", WordWeight);
            material.SetColor("_Color", WordColor);

            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            TestTag = 0;
            Graphics.Blit(sourceTexture, destTexture);
        }


    }

    // Update is called once per frame
    void Update()
    {


    }
}
