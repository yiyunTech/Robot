Shader "Custom/OpaVideo" {
	Properties  
    {  
        //_Color ("Color", Color) = (1,1,1,1)  
        _MainTex ("Albedo (RGB)", 2D) = "black" {} 

		//_VideoTex1("Video1", 2D) = "black"{}
		//_VideoTex2("Video2", 2D) = "black"{}
		//_VideoTex1("Video1", 2D) = "black"{}
		
		_SnowTex("SnowTex", 2D) = "white"{}

		_SnowOffsetx("SnowTexOffsetx", float) = 0.0
        _SnowOffsety("SnowTexOffsety", float) = 0.0
		_TotalAlpha("TotalAlpha", float) = 0.0
		
    }  
    SubShader  
    {  
    //Tags { "Queue"="Transparent" "RenderType"="Transparent" }  
	Tags{"Queue"="Transparent" "RenderType"="Opaque"}
        LOD 200  
        
        CGPROGRAM  
        // Physically based Standard lighting model, and enable shadows on all light types  
        #pragma surface surf Standard alpha  
    
        // Use shader model 3.0 target, to get nicer looking lighting  
        //#pragma target 3.0  
    
        sampler2D _MainTex;  
		//sampler2D _VideoTex1;
		//sampler2D _VideoTex2;

		sampler2D _SnowTex;
		float _SnowOffsetx;
		float _SnowOffsety;
		float _TotalAlpha;
		float _Threshold;
		int _CaseIdx;
        //sampler2D _AlphaVideo;  

		float _IdTex=0;
    
        struct Input {  
            float2 uv_MainTex;  
            float2 uv_SnowTex; 
			float2 uv_VideoTex1;
			float2 uv_VideoTex2;

        };  
		

		
        
    
        void surf (Input IN, inout SurfaceOutputStandard o) {  

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex); 
			if(_CaseIdx==0)
			{
				//o.Albedo = c.rgb;// + v1.rgb + v2.rgb;  
				o.Albedo = float3(0.0,0.0,0.0);
			}
			else if(_CaseIdx==1)
			{
				fixed4 s = tex2D (_SnowTex, IN.uv_SnowTex);  
				//o.Albedo = s.rgb;
				//o.Albedo = c.rgb;
				o.Albedo = float3(0.0,0.0,0.0);
			}
            else
			{
				o.Albedo = float3(0.0,0.0,0.0);
			}

			 float _alpha = 0;
			if((c.r +c.g + c.b)> _Threshold)
			{
		   		_alpha = 1.0;
			}
            o.Alpha = _alpha * _TotalAlpha;  

        }  
        ENDCG  
    }  
    FallBack "Diffuse" 
}
