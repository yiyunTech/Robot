Shader "Custom/VisualMusicBack" {
	Properties {
		//_Color ("Color", Color) = (1,1,1,1)
		//_Color ("Main Color", Color) = (1,1,1,1)
		_Color("Alpha Color Key", Color) = (0,0,0,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_AlphaThred("Alpha Threshold", float) = 0.2
		_Range("Range",Range(0,1.01)) = 0.1
		
		_Test("Test value", float) = 0.0

		//_MusicTex("Music Video", 2D) = "black"{}

	}
	SubShader  
    {  
    //Tags { "Queue"="Transparent" "RenderType"="Transparent" }  
	Tags{"Queue"="Transparent" "RenderType"="Transparent"}
        LOD 200  
        
        CGPROGRAM  
        
        #pragma surface surf Standard alpha  
		//#pragma surface surf BlinnPhong Alpha Blending
        //#pragma target 3.0
    
        
        sampler2D _MainTex;  
		float _AlphaThred;
		float4 _Color;
		float _Range;

		float _Test;

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
        struct Input {  
            float2 uv_MainTex;  
            
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

            o.Albedo = cc.rgb;
			o.Emission = (cc-_Range)*(cc-_Range) * (v - _Range) * (v - _Range) * (v - _Range) * 3.0;
			o.Alpha = (v - _Range) * (v - _Range) * (v - _Range) *10;

			clip(o.Alpha-0.001);

        }  
        ENDCG  
    }  
    FallBack "Diffuse" 
}
