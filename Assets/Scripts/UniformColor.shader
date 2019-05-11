
Shader "Custom/UniformColor" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_LuminosityAmount ("GrayScale Amount", Range(0.0, 1.0)) = 1.0
		_ContrastRatio("Contrast Ratio", float) = 1.0
		//_ConsistentColor("Color", float4) = (1.0,1.0,1.0, 1.0)
		_ConsistentColorR("ColorR", float) = 1.0
		_ConsistentColorG("ColorG", float) = 1.0
		_ConsistentColorB("ColorB", float) = 1.0

		_Luminance("Luminance", float) = 1.0
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
			

			
			
			float4 frag(v2f_img i) : COLOR
			{
				float2 uv = i.uv;
				fixed4 renderTex;
				renderTex = tex2D(_MainTex, float2(uv.x, uv.y));


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
