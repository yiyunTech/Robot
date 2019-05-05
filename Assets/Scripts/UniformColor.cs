
using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class UniformColor : MonoBehaviour
{
    #region Variables
    public Shader curShader;
    public float grayScaleAmount = 1.0f;
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

    // Use this for initialization
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
            material.SetFloat("_LuminosityAmount", grayScaleAmount);
            material.SetFloat("_Luminance", Lumin);


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
