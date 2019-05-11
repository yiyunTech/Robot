
Shader "Custom/UniformColorBack" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_LuminosityAmount ("GrayScale Amount", Range(0.0, 1.0)) = 1.0
		_ContrastRatio("Contrast Ratio", float) = 1.0
		//_ConsistentColor("Color", float4) = (1.0,1.0,1.0, 1.0)
		_ConsistentColorR("ColorR", float) = 1.0
		_ConsistentColorG("ColorG", float) = 1.0
		_ConsistentColorB("ColorB", float) = 1.0

		_Luminance("Luminance", float) = 1.0
		_UseNoise("Use Noise", int) = 1
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			uniform sampler2D _MainTex;
			fixed _LuminosityAmount;
			float _ContrastRatio;
			//float4 _ConsistentColor;
			float _ConsistentColorR;
			float _ConsistentColorG;
			float _ConsistentColorB;

			float _Luminance;
			bool _UseNoise;

 
			float2 _MainTex_TexelSize;
 
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
				
				
				if(_UseNoise==1)
				{
					

					float u = i.uv.x;
					float v = i.uv.y;
 
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
					renderTex = tex2D(_MainTex, float2(uv.x, uv.y));
				}
				

				
				//Apply the Luminosity values to our render texture
				
				float luminosity = 0.299 * renderTex.r + 0.587 * renderTex.g + 0.114 * renderTex.b;
				//luminosity = atan(_ContrastRatio * (luminosity - 0.5)) / 3.1415926 + 0.5001;
				luminosity = luminosity * luminosity;
				float4 finalColor = lerp(renderTex, _Luminance * luminosity * float4(_ConsistentColorR, _ConsistentColorG, _ConsistentColorB, 1.0), _LuminosityAmount);
				//fixed4 finalColor = _LuminosityAmount * luminosity * renderTex * _ConsistentColor;



				


				return finalColor;
			}
			
			ENDCG
		}
	}
	FallBack "Diffuse"
}
