using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class OpaVideo : MonoBehaviour
{



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
    //public bool[] 


    float _totalAlpha = 0.0f;


    // Use this for initialization
    void Start()
    {
        CurRand = new System.Random();

        _videoPlayer = this.GetComponent<VideoPlayer>();
        //_videoPlayer[CurVideo].Play();
    }

    void _videoPlay()
    {
        _isDisplay = true;

        _durationTime = 0.0f;

        CurVideo = CurRand.Next(0, 1);
        _videoPlayer.clip = AllVideoCilps[CurVideo];

        _videoPlayer.Play();
        _totalAlpha = 1.0f;

        GetComponent<Renderer>().material.SetFloat("_Threshold", Threshold[CurVideo]);
        GetComponent<Renderer>().material.SetInt("_CaseIdx", CurVideo);

    }

    void _videoStop()
    {
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

    // Update is called once per frame
    void Update()
    {
        _updateVideoState();
        //_videoPlay();

        float CurOffset1 = 0f;
        float CurOffset2 = 0f;
        CurOffset1 = (float)CurRand.NextDouble();
        CurOffset2 = (float)CurRand.NextDouble();


        GetComponent<Renderer>().material.SetFloat("_SnowOffsetx", CurOffset1);
        GetComponent<Renderer>().material.SetFloat("_SnowOffsety", CurOffset2);
        GetComponent<Renderer>().material.SetFloat("_TotalAlpha", _totalAlpha);

    }
}
