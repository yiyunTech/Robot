Shader "Custom/OpaVideo" {
	Properties  
    {  
        //_Color ("Color", Color) = (1,1,1,1)  
        _MainTex ("Albedo (RGB)", 2D) = "white" {} 
		
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
		sampler2D _SnowTex;
		float _SnowOffsetx;
		float _SnowOffsety;
		float _TotalAlpha;
        //sampler2D _AlphaVideo;  
    
        struct Input {  
            float2 uv_MainTex;  
            float2 uv_SnowTex;  
        };  
    
        
    
        void surf (Input IN, inout SurfaceOutputStandard o) {  
            // Albedo comes from a texture tinted by color  
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);  
			fixed4 s = tex2D (_SnowTex, IN.uv_SnowTex+float2(_SnowOffsetx, _SnowOffsety));
            o.Albedo = s.rgb;  
            // Metallic and smoothness come from slider variables  
           
		   float _alpha = 0;
		   if((c.r +c.g + c.b)> 0.1)
		   {
		   	   _alpha = 1.0;
		   }
            o.Alpha = _alpha * _TotalAlpha;  
              
        }  
        ENDCG  
    }  
    FallBack "Diffuse" 
}
