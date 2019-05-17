Shader "Custom/RobotShader2" {
	Properties {
        _TexStatic ("Static", 2D) = "white" {}
		_ColorStatic("Static Color", Color) = (1, 1, 1, 1)


        _TexDynamic ("Dynamic", 2D) = "white" {}
		_AlphaValue("Alpha Value", Range(0.0,1.0)) = 1.0
		//_Offset("DynamicOffset", float) = 0.0

		//_MainTex("Albedo", 2D) = "white"{}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0


		_ColorFactor("ColorFactor", float) = 1
		_DynamicFactor("Dynamic Factor", Range(0.0, 1.0))=0.0

		
    }

	SubShader  
    {  
    //Tags { "Queue"="Transparent" "RenderType"="Transparent" }  
		Tags {"Queue"="Transparent" "RenderType"="Opaque"}
        LOD 200  
        
        CGPROGRAM  
        // Physically based Standard lighting model, and enable shadows on all light types  
        #pragma surface surf Standard alpha  


		sampler2D _TexStatic;
        sampler2D _TexDynamic;
		float4 _ColorStatic;
 
        float _AlphaValue;
		//float _Offset;
		float _ColorFactor;
		float _DynamicFactor;

		float _Glossiness;
		float _Metallic;

		
 

        struct Input {
            float2 uv_TexStatic;
            float2 uv_TexDynamic;
			//float4 xy_Position : POSITION;
			float3 worldPos;
        };

		//UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		//UNITY_INSTANCING_BUFFER_END(Props)

 
        void surf (Input IN, inout SurfaceOutputStandard o) {
            
               
            //o.Albedo = tex2D(_TexStatic, IN.uv_TexStatic).rgb * tex2D(_TexDynamic, IN.uv_TexDynamic).rgb;\
			//float2 UV_Dynamic = IN.uv_TexDynamic;
			//UV_Dynamic += (0, _Offset); 

			
			//_Offset = IN.xy_Position.x;
			float utmp = IN.worldPos.x / 1.0;
			float vtmp = IN.worldPos.y / 1.0;

			//float utmp = IN.uv_TexDynamic.x;
			//float vtmp = IN.uv_TexDynamic.y;

			float ut = utmp; //0.7071 * utmp + 0.7071 * vtmp;
			float vt = vtmp;//0.7071 * utmp - 0.7071 * vtmp;


			float4 c = tex2D(_TexStatic, IN.uv_TexStatic)* _ColorStatic;
			o.Albedo = _ColorFactor * (_DynamicFactor * tex2D(_TexDynamic, float2(ut, vt)).rgb + (1.0 - _DynamicFactor) * ( c.rgb));


			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = _AlphaValue ;
        }
        ENDCG
    }
    FallBack "Diffuse"



	/*
	Properties {
        _TexStatic ("Static", 2D) = "white" {}
		_ColorStatic("Static Color", Color) = (1, 1, 1, 1)


        _TexDynamic ("Dynamic", 2D) = "white" {}
		_AlphaValue("Alpha Value", Range(0.0,1.0)) = 1.0
		//_Offset("DynamicOffset", float) = 0.0

		//_MainTex("Albedo", 2D) = "white"{}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0


		_ColorFactor("ColorFactor", float) = 1
		_DynamicFactor("Dynamic Factor", Range(0.0, 1.0))=0.0

		
    }
    SubShader {
        //Tags {"Queue" = "Transparent" }
		//Tags { "RenderType"="Opaque" "Queue" = "Transparent" }
		//Tags { "RenderType"="Transparent" "IgnoreProjector"="True" "Queue"="Transparent" }
		Tags{"Queue"="Transparent" "RenderType"="Opaque"}
		LOD 200

		//Blend SrcAlpha OneMinusSrcAlpha
		//Blend One One
		Blend One OneMinusSrcAlpha 

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Standard Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

       
        sampler2D _TexStatic;
        sampler2D _TexDynamic;
		float4 _ColorStatic;
 
        float _AlphaValue;
		//float _Offset;
		float _ColorFactor;
		float _DynamicFactor;

		float _Glossiness;
		float _Metallic;

		
 

        struct Input {
            float2 uv_TexStatic;
            float2 uv_TexDynamic;
			//float4 xy_Position : POSITION;
			float3 worldPos;
        };

		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

 
        void surf (Input IN, inout SurfaceOutputStandard o) {
            
               
            //o.Albedo = tex2D(_TexStatic, IN.uv_TexStatic).rgb * tex2D(_TexDynamic, IN.uv_TexDynamic).rgb;\
			//float2 UV_Dynamic = IN.uv_TexDynamic;
			//UV_Dynamic += (0, _Offset); 

			
			//_Offset = IN.xy_Position.x;
			float utmp = IN.worldPos.x / 1.0;
			float vtmp = IN.worldPos.y / 1.0;

			//float utmp = IN.uv_TexDynamic.x;
			//float vtmp = IN.uv_TexDynamic.y;

			float ut = utmp; //0.7071 * utmp + 0.7071 * vtmp;
			float vt = vtmp;//0.7071 * utmp - 0.7071 * vtmp;


			float4 c = tex2D(_TexStatic, IN.uv_TexStatic)* _ColorStatic;
			o.Albedo = _ColorFactor * (_DynamicFactor * tex2D(_TexDynamic, float2(ut, vt)).rgb + (1.0 - _DynamicFactor) * ( c.rgb));


			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = _AlphaValue ;
        }
        ENDCG
    }
    FallBack "Diffuse"

	*/
}
