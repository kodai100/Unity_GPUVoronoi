Shader "Custom/Cone" {

	Properties{
		_DotSize("Dot Size", Range(0, 0.1)) = 0.01
		_Size("Size", Range(0, 10)) = 1
		_Height("Height", Range(0,1)) = 1
	}

	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGINCLUDE

		#pragma target 5.0
		#include "UnityCG.cginc"
		#define PI 3.1415926535

		float _DotSize;
		float _Size;
		float _Height;

		struct appdata {
			float4 vertex : POSITION;
			float2 colorIdx : TEXCOORD0;
		};

		struct v2g {
			float4 vertex : POSITION;
			float2 colorIdx : TEXCOORD0;
		};

		struct g2f {
			float4 pos : SV_POSITION;
			float2 colorIdx : TEXCOORD0;
		};

		v2g vert(appdata IN) {
			v2g OUT;

			OUT.vertex = IN.vertex;
			OUT.colorIdx = IN.colorIdx;

			return OUT;
		}

		// division * 3 + 4
		[maxvertexcount(154)]
		void geom_square(point v2g IN[1], inout TriangleStream<g2f> OUT) {

			g2f pIn;

			float4 top = IN[0].vertex;
			float2 color = IN[0].colorIdx;

			//
			float size = _DotSize;
			float halfS = 0.5f * size;
			for (int x = 0; x < 2; x++) {
				for (int y = 0; y < 2; y++) {
					float4x4 billboardMatrix = UNITY_MATRIX_V;
					billboardMatrix._m03 = billboardMatrix._m13 = billboardMatrix._m23 = billboardMatrix._m33 = 0;
					pIn.pos = float4(top.x, top.y, 0.1, 1) + mul(float4((float2(x, y) * 2 - float2(1, 1)) * halfS, 0, 1), billboardMatrix);
					pIn.pos = mul(UNITY_MATRIX_VP, pIn.pos);
					pIn.colorIdx = float2(0, 0);
					OUT.Append(pIn);
				}
			}
			OUT.RestartStrip();

			
			// Cone
			uint division = 50;
			for (uint i = 0; i < division; i++) {
				float digree = 360 / division;
				float x = _Size * cos((i % division) * digree / 180 * PI);
				float y = _Size * sin((i % division) * digree / 180 * PI);
				float x_next = _Size * cos(((i+1) % division) * digree / 180 * PI);
				float y_next = _Size * sin(((i+1) % division) * digree / 180 * PI);

				pIn.pos = mul(UNITY_MATRIX_MVP, float4(top.x, top.y, 0, 1));
				pIn.colorIdx = color;
				OUT.Append(pIn);
				pIn.pos = mul(UNITY_MATRIX_MVP, float4(top.x + x, top.y + y, -_Height, 1));
				pIn.colorIdx = color;
				OUT.Append(pIn);
				pIn.pos = mul(UNITY_MATRIX_MVP, float4(top.x + x_next, top.y + y_next, -_Height, 1));
				pIn.colorIdx = color;
				OUT.Append(pIn);
				OUT.RestartStrip();
			}
		}

		float3 hsv2rgb(float3 c) {
			float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
			return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		}

		ENDCG

		Pass{
			ZWrite On

			CGPROGRAM

			#pragma vertex vert
			#pragma geometry geom_square
			#pragma fragment frag

			fixed4 frag(g2f IN) : SV_Target{
				fixed3 rgb = (float3)hsv2rgb(float3(IN.colorIdx.x,1,IN.colorIdx.y));
				return fixed4(rgb, 1);
			}

			ENDCG
		}

	}
}
