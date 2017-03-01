Shader "Custom/Billboard" {

	Properties{
		_Size("Size", Range(0, 10)) = 1
	}

		SubShader{
			Tags{ "RenderType" = "Opaque" }
			LOD 200

			CGINCLUDE

			#pragma target 5.0
			#include "UnityCG.cginc"

			float _Size;

		struct appdata {
			float4 vertex : POSITION;
		};

		struct v2g {
			float4 vertex : POSITION;
		};

		struct g2f {
			float4 pos : SV_POSITION;
		};

		v2g vert(appdata IN) {
			v2g OUT;

			OUT.vertex = IN.vertex;

			return OUT;
		}

		[maxvertexcount(4)]
		void geom_square(point v2g IN[1], inout TriangleStream<g2f> OUT) {

			float size = _Size;
			float halfS = 0.5f * size;

			g2f pIn;

			for (int x = 0; x < 2; x++) {
				for (int y = 0; y < 2; y++) {
					float4x4 billboardMatrix = UNITY_MATRIX_V;
					billboardMatrix._m03 = billboardMatrix._m13 = billboardMatrix._m23 = billboardMatrix._m33 = 0;

					float2 uv = float2(x, y);

					pIn.pos = IN[0].vertex + mul(float4((uv * 2 - float2(1, 1)) * halfS, 0, 1), billboardMatrix);

					pIn.pos = mul(UNITY_MATRIX_VP, pIn.pos);

					OUT.Append(pIn);
				}
			}

		}

		ENDCG

		Pass{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite On

			CGPROGRAM

			#pragma vertex vert
			#pragma geometry geom_square
			#pragma fragment frag

			fixed4 frag(g2f IN) : SV_Target{
				return fixed4(1, 0, 0, 1);
			}

			ENDCG
		}

	}
}
