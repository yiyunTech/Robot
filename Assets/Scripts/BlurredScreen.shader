Shader "Custom/BlurredScreen" {
	Properties  
    {  
        //_Color ("Color", Color) = (1,1,1,1)  
        _MainTex ("Albedo (RGB)", 2D) = "white" {} 

		_VideoTex("Video", 2D) = "black"{}
		//_VideoTex2("Video2", 2D) = "black"{}
		//_VideoTex1("Video1", 2D) = "black"{}
		
		_SnowTex("SnowTex", 2D) = "white"{}

		_SnowOffsetx("SnowTexOffsetx", float) = 0.0
        _SnowOffsety("SnowTexOffsety", float) = 0.0
		_TotalAlpha("TotalAlpha", float) = 0.0
		
    }  
    SubShader  
    {  

		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
    
        

			// Use shader model 3.0 target, to get nicer looking lighting  
			//#pragma target 3.0  
    
			sampler2D _MainTex;  
			sampler2D _VideoTex;
			//sampler2D _VideoTex2;

			sampler2D _SnowTex;
			float _SnowOffsetx;
			float _SnowOffsety;
			float _TotalAlpha;
			float _Threshold;
			int _CaseIdx;
			//sampler2D _AlphaVideo;  


			float2 _ScanLineJitter; 
			float2 _VerticalJump;
			float _HorizontalShake;
			float2 _ColorDrift;

			float _IdTex=0;
    

		


			float nrand(float x, float y)
			{
				return frac(sin(dot(float2(x, y), float2(12.9898, 78.233))) * 43758.5453);
			}

			float4 getNoise(float2 uv)
			{
				fixed4 renderTex;



				
				float u = uv.x;
				float v = uv.y;
 
						//扫描线
				float jitter = nrand(v, _Time.x) * 2 - 1;
				jitter *= step(_ScanLineJitter.y, abs(jitter)) * _ScanLineJitter.x;
 
							//画面垂直跳
				float jump = lerp(v, frac(v + _VerticalJump.y), _VerticalJump.x);
 
						//画面左右震动
				float shake = (nrand(_Time.x, 2) - 0.5) * _HorizontalShake;
 
						//颜色偏移
				float drift = sin(jump + _ColorDrift.y) * _ColorDrift.x;
 
				float4 src1 = tex2D(_MainTex, frac(float2(u + jitter + shake, jump)));
				float4 src2 = tex2D(_MainTex, frac(float2(u + jitter + shake + drift, jump)));

				renderTex = float4(src1.r, src2.g, src1.b, 1);


				return renderTex;
			}
		
        
    
			float4 frag(v2f_img i) : COLOR 
			{
				float2 uv = i.uv;
				float4 o;
				
				fixed4 c = tex2D (_MainTex, uv); 
				o.xyz = c.rgb;

				if(_CaseIdx==0)
				{
					//o.Albedo = c.rgb;// + v1.rgb + v2.rgb;  
					//o.xyz = float3(0.0,0.0,0.0);

					fixed4 s = tex2D (_VideoTex, uv); 
					if((s.r +s.g + s.b)> _Threshold)
					{
		   				o.xyz = float3(0.0,0.0,0.0);
						
					}
					
				}

				else if(_CaseIdx==1)
				{
					//o.Albedo = c.rgb;// + v1.rgb + v2.rgb;  
					//o.xyz = float3(0.0,0.0,0.0);

					fixed4 s = tex2D (_VideoTex, uv); 
					if((s.r +s.g + s.b)> _Threshold)
					{
		   				o.xyz = s.rgb;
					}
					
				}
				else if(_CaseIdx==2)
				{
					//fixed4 s = tex2D (_SnowTex, uv);  
					//o.Albedo = s.rgb;
					//o.Albedo = c.rgb;
					//o.Albedo = float3(0.0,0.0,0.0);
					o.xyz = getNoise(uv).rgb;
				}
				

				// float _alpha = 0;
			
				//o.Albedo = float3(1.0,0.0,0.0);
				o.w = 1.0f;
				return o;
			}  
			ENDCG  

		}
    }  
    FallBack "Diffuse" 
}
