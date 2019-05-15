Shader "Custom/VisualMusic" {
	Properties {
		//_Color ("Color", Color) = (1,1,1,1)
		//_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_AlphaThred("Alpha Threshold", float) = 0.2
		_Range("Range",Range(0,1.01)) = 0.1
		
		_Test("Test value", float) = 0.0
		_TestColor("Test Color", Color) = (0,0,0,0)

		_MusicTex("Music Video", 2D) = "black"{}
		_MusicScaleX("Music Tex Scale X", Range(0.0,1.0)) = 1.0
		_MusicScaleY("Music Tex Scale Y", Range(0.0,1.0)) = 1.0
		_MusicOffsetX("Music Offset X", Range(0.0,1.0)) = 0.0
		_MusicOffsetY("Music Offset Y", Range(0.0,1.0)) = 0.0
		_MusicColor("Music Color", Color) = (1,0,0,1)
		_MusicCustomColor("Misic Custom Coloro", int) = 0
		_MusicLumnosity("Music luminosity", Range(0.1, 20.0)) = 3.0
		_Contrast("Music contrast", Range(0.1, 20.0)) = 3.0
		_Contrast2("Music contrast2", Range(0.1, 5.0)) =1.0
	}
	SubShader  
    {  
		//Tags { "Queue"="Transparent" "RenderType"="Transparent" }  
		//Tags{"RenderType"="Opaque"}
        LOD 200  
        
        CGPROGRAM  
        
        #pragma surface surf Standard
		//#pragma surface surf BlinnPhong Alpha Blending
        //#pragma target 3.0
    
        
        sampler2D _MainTex;  
		float _AlphaThred;
		float4 _MusicColor;
		float _Range;

		sampler2D _MusicTex;
		float _MusicScaleX;
		float _MusicScaleY;
		float _MusicOffsetX;
		float _MusicOffsetY;
		int _MusicCustomColor;
		float _MusicLumnosity;
		float _Contrast;
		float _Contrast2;


		float _Test;
		float4 _TestColor;

		/*
		//命名规则：Lighting接#pragma suface之后起的名字 
  		//lightDir :点到光源的单位向量   viewDir:点到摄像机的单位向量   atten:衰减系数 
		float4 LightingmyLightModel(SurfaceOutput s, float3 lightDir,half3 viewDir, half atten) 
  		{ 
  		 	float4 c ; 
  		 	c.rgb =  s.Albedo;
  			c.a = s.Alpha; 
    		return c; 
  		}
		*/

		float3 sigmoidColor(float3 c)
		{
			//float3 e = exp(c);
			return 1.0 / (exp(-c) + 1.0) ;
		}



        struct Input {  
            float2 uv_MainTex;  
            float2 uv_MusicTex;
			float4 _Color;
        };  
		


		
        
    
        void surf (Input IN, inout SurfaceOutputStandard o) {  
			/*
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex)* _Color; 
			o.Albedo = c.rgb;

			float cur_alpha = ((c.r + c.g + c.b) * (c.r + c.g + c.b) - 0.3f) / 3.0f;// ( c.b*c.b  - 0.3) / 0.5f; // ((c.b*-1) + 1)*-1;

			
			if(c.b>_AlphaThred)
			{
				cur_alpha = 1.0f;
			}
			else
			{
				cur_alpha = 0.0f;
			}

			o.Alpha = cur_alpha;  
			*/


			_Test = o.Alpha;
			half4 cc = tex2D(_MainTex, IN.uv_MainTex);
			float v = (cc.r + cc.g + cc.b) / 3;

			float2 mt_uv = IN.uv_MusicTex;
			mt_uv = mt_uv - float2(_MusicOffsetX, _MusicOffsetY);
			mt_uv = float2(mt_uv.x / _MusicScaleX, mt_uv.y / _MusicScaleY);

			if(mt_uv.x >0 && mt_uv.x<1.0 && mt_uv.y>0 && mt_uv.y<1)
			{
				float4 mt = tex2D(_MusicTex, mt_uv);
				float luminosity = 0.299 * mt.r + 0.587 * mt.g + 0.114 * mt.b;
				if(_MusicCustomColor)
				{
					
					//mt = float4(_Color.r * luminosity, _Color.g * luminosity, _Color.b * luminosity, 1.0);
					//mt = float4(luminosity, luminosity, luminosity, 1.0);
					
					mt = _MusicColor * luminosity;
				}
				

				//float gamma = 1.0f;
				if(luminosity>_Range)
				{
					//gamma = 0.0f;
					float3 new_em = mt.rgb *mt.rgb * mt.rgb;
					float new_lumin = 0.299 * new_em.r + 0.587 * new_em.g + 0.114 * new_em.b;
					//new_em = new_em * 3.0; //* luminosity / new_lumin;

					//new_em = atan(_Contrast* (new_em)) / 3.1415926 ;//+ 0.5001;
					//new_em = sigmoidColor( _Contrast * (_Contrast2 * new_em-float3(0.5,0.5,0.5)) );

					o.Emission = new_em * _MusicLumnosity;// * luminosity / new_lumin;
				}
				//else{
				//	o.Emission = mt.rgb;
				//}
				//o.Albedo = (1.0 - gamma) * cc.rgb + gamma * mt.rgb;
				
			}
			//else
			//{
			//	o.Albedo = cc.rgb;
			//}

			o.Albedo = cc.rgb;
			o.Alpha = 1.0;

			//_TestColor = cc.rgb;

            //v = 1 - v;
            // half4 color = half4(v, v, v, v);
            //float4 oo = float4(1, 0, 0, 0.2);
            //half4 c = color;
            //oo.rgb = c.rgb;
            //if ((v - _Color.r)<_Range && (v - _Color.g)<_Range && (v - _Color.b)<_Range) 
			

			/*
			if( (v<_Range))
            {        
				//o.Albedo = cc.rgb;
				//o.Alpha = ((cc.r + cc.g + cc.b) * (cc.r + cc.g + cc.b) - 0.3f) / 3.0f;


				clip(o.Alpha - 1);
            }
			
            else{
				//cc.Alpha = (v*v - _Range*_Range);
				o.Emission = (cc-_Range)*(cc-_Range)/0.3;
				o.Albedo = cc.rgb;
				o.Alpha = (v*v - _Range*_Range)*2;
				
			}
			*/

			//o.Albedo = cc.rgb;
			//o.Alpha = cc.w;
			//_Test = o.Alpha;

            //o.Albedo = cc.rgb;
			//o.Emission = (cc-_Range)*(cc-_Range) * (v - _Range) * (v - _Range) * (v - _Range) * 3.0;
			//o.Alpha = (v - _Range) * (v - _Range) * (v - _Range) *10;

			//clip(o.Alpha-0.001);

        }  
        ENDCG  
    }  
    FallBack "Diffuse" 
}
