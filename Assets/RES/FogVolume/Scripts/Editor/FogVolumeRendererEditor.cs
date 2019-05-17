﻿using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditorInternal;

[CustomEditor(typeof(FogVolumeRenderer))]

public class FogVolumeRendererEditor : Editor
{
    FogVolumeRenderer _target;
    private Texture2D InspectorImage;
    private GUIStyle HeaderStyle, BodyStyle;
    private static bool ShowInspectorTooltips
    {
        get { return EditorPrefs.GetBool("ShowInspectorTooltips"); }
        set { EditorPrefs.SetBool("ShowInspectorTooltips", value); }
    }
    GUIContent VariableField(string VariableName, string Tooltip)
    {
        return new GUIContent(VariableName, ShowInspectorTooltips ? Tooltip : "");
    }

    string[] layerMaskName;
    //int layerMaskNameIndex = 0;

 
    void OnEnable()
    {
        _target = (FogVolumeRenderer)target;
        InspectorImage = Resources.Load("InspectorImage", typeof(Texture2D)) as Texture2D;
        HeaderStyle = new GUIStyle();
        HeaderStyle.normal.background = InspectorImage;
        BodyStyle = new GUIStyle();
        // BodyStyle.normal.background = (Texture2D)Resources.Load("RendererInspectorBody");
        if (EditorGUIUtility.isProSkin)
            BodyStyle.normal.background = (Texture2D)Resources.Load("RendererInspectorBodyBlack");
        else
            BodyStyle.normal.background = (Texture2D)Resources.Load("RendererInspectorBodyBright");
        
        List<string> layerMaskList = new List<string>();
        for (int i = 0; i < 32; i++)
        {
            string layerName = LayerMask.LayerToName(i);
            //if (layerName != "")
            //{
               // if (layerName == _target.DepthLayersName)
               //     layerMaskNameIndex = layerMaskList.Count;
                layerMaskList.Add(layerName);
            //}
        }
        layerMaskName = layerMaskList.ToArray();
    }
   
    public override void OnInspectorGUI()
    {

        serializedObject.Update();
        GUILayout.Space(10);
        // GUILayout.Box(InspectorImage, GUILayout.ExpandWidth(true));
        GUILayout.BeginVertical(HeaderStyle);

        // EditorGUILayout.HelpBox(BodyStyle.name, MessageType.None);
        GUILayout.Space(EditorGUIUtility.currentViewWidth / 4 - 10);
        //end header        
        GUILayout.EndVertical();
        //begin body
        GUILayout.BeginVertical(BodyStyle);

        EditorGUI.BeginChangeCheck();
        Undo.RecordObject(_target, "Fog volume Renderer parameter");

        GUILayout.Space(20);
        // GUILayout.BeginVertical("box");
        _target._Downsample = EditorGUILayout.IntSlider("Downscale", _target._Downsample, 0, 16);
        if (_target._Downsample>0)
   //     _target.RenderableInSceneView = EditorGUILayout.Toggle(VariableField("Render In Scene View", "Makes it visible for reflection probes and Scene viewport"), _target.RenderableInSceneView);

        //GUILayout.EndVertical();//end box
        if (_target._Downsample > 0)
            _target._BlendMode = (FogVolumeRenderer.BlendMode)EditorGUILayout.EnumPopup("Blend Mode", _target._BlendMode);
        EditorGUILayout.HelpBox("Resolution: " + _target.FogVolumeResolution, MessageType.None);
        if (_target._Downsample > 0)
        {

            GUILayout.BeginVertical("box");
            _target.GenerateDepth = EditorGUILayout.Toggle(VariableField("Depth", "Compute Depth when rendered in low-res and textured volumes collide with scene elements"), _target.GenerateDepth);
            if (_target.GenerateDepth)
            {
                //GUILayout.BeginHorizontal();
                //EditorGUILayout.LabelField("Exclude layer");
                //int newLayerMaskNameIndex = EditorGUILayout.Popup(layerMaskNameIndex, layerMaskName);
                //if (newLayerMaskNameIndex != layerMaskNameIndex)
                //{
                //    layerMaskNameIndex = newLayerMaskNameIndex;
                //    _target.DepthLayersName = layerMaskName[layerMaskNameIndex];

                //}
                //GUILayout.EndHorizontal();
                // GUILayout.BeginHorizontal();
                // EditorGUILayout.LabelField("Depth layers");
                _target.DepthLayer2 = EditorGUILayout.MaskField(VariableField("Depth layers", "Select the layers used to collide with FV\n(Experimental feature)"), _target.DepthLayer2, layerMaskName);
                //_target.DepthLayer2 = EditorGUILayout.LayerField("Depth layers", _target.DepthLayer2);
                //GUILayout.EndHorizontal();
                GUILayout.BeginVertical("box");
                _target.BilateralUpsampling = EditorGUILayout.Toggle(VariableField("Edge-aware upscale", "Minimize the aliasing at the edges of colliding elements"), _target.BilateralUpsampling);


                if (_target.BilateralUpsampling)
                {
                    _target.upsampleDepthThreshold = EditorGUILayout.Slider("Depth Threshold", _target.upsampleDepthThreshold, 0, .01f);
                    _target.ShowBilateralEdge = EditorGUILayout.Toggle("Show edge mask", _target.ShowBilateralEdge);
                    _target.USMode = (FogVolumeCamera.UpsampleMode)EditorGUILayout.EnumPopup("Method", _target.USMode);
                    
                }
                GUILayout.EndVertical();//end box
            }
            GUILayout.EndVertical();//end box

            #region DeNoise
            if (_target._Downsample > 0)
            {
                GUILayout.BeginVertical("box");
                _target.TAA = EditorGUILayout.Toggle(VariableField("DeNoise", "Performs Playdead's TAA to minimize noise when using jitter. Note: effect works only in 5.5"), _target.TAA);
                if (_target.TAA && _target.HDR)
                    EditorGUILayout.HelpBox("Color output is in LDR", MessageType.None);
                GUILayout.EndVertical();//end box

            }
            #endregion

          //  #region Stereo
            //if ( _target._Downsample > 0)
            //{
            //    GUILayout.BeginVertical("box");
            //    _target.useRectangularStereoRT = EditorGUILayout.Toggle("Rectangular stereo", _target.useRectangularStereoRT);
            //    GUILayout.EndVertical();//end box
            //}
          //  #endregion


        }

        EditorGUI.EndChangeCheck();
        EditorGUILayout.HelpBox("Fog Volume 3.2.1p3 September 2017", MessageType.None);
        GUILayout.EndVertical();
        if (GUI.changed)
        {
            EditorUtility.SetDirty(_target);
        }



        serializedObject.ApplyModifiedProperties();
    }


}
