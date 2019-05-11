Shader "Custom/SignalNoise" {
	

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			uniform sampler2D _MainTex;
 
			int _UseNoise;
			float2 _ScanLineJitter; 
			float2 _VerticalJump;
			float _HorizontalShake;
			float2 _ColorDrift;


			float nrand(float x, float y)
			{
				return frac(sin(dot(float2(x, y), float2(12.9898, 78.233))) * 43758.5453);
			}
			
			float4 frag(v2f_img i) : COLOR
			{
				fixed4 renderTex;


				// random noise
				float2 uv = i.uv;
				
				float u = i.uv.x;
				float v = i.uv.y;
 
				if(_UseNoise==1)
				{
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
				}
				else
				{
					renderTex = tex2D(_MainTex, uv);
				}


				return renderTex;
			}

			
			ENDCG
		}
	}

	FallBack "Diffuse"
}
