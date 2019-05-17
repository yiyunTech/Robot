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


   

    // Use this for initialization
    void Start()
    {
        _videoPlayer = GetComponents<VideoPlayer>()[1];
        _videoPlayer.clip = video;

        //_videoPlayer = this.GetComponent<VideoPlayer>();
        _videoPlayer.Play();

    }



    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {

        
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
