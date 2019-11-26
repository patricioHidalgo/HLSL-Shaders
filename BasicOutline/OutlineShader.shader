// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDev/OutlineShader"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "White" {}
		_Outline("Outline", Range(0, 1)) = 0.1
		_OutlineColour("Colour", Color) = (1,1,1,1)
	}

		SubShader
		{
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }


			Pass
		{
			ZWrite Off
			Cull front
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
#pragma vertex vert
#pragma fragment frag

			uniform half _Outline;
		uniform half4 _OutlineColour;


		struct vertexInput
		{
			float4 vertex : POSITION;
		};

		struct vertexOutput
		{
			float4 pos : SV_POSITION;
		};

		float4 Outline(float4 vertPos, float outline)
		{
			float4x4 scaleMatrix;

			scaleMatrix[0][0] = 1.0f + outline;
			scaleMatrix[0][1] = 0.f;
			scaleMatrix[0][2] = 0.f;
			scaleMatrix[0][3] = 0.f;

			scaleMatrix[1][0] = 0.f;
			scaleMatrix[1][1] = 1.0f + outline;
			scaleMatrix[1][2] = 0.f;
			scaleMatrix[1][3] = 0.f;

			scaleMatrix[2][0] = 0.f;
			scaleMatrix[2][1] = 0.f;
			scaleMatrix[2][2] = 1.0f + outline;
			scaleMatrix[2][3] = 0.f;

			scaleMatrix[3][0] = 0.f;
			scaleMatrix[3][1] = 0.f;
			scaleMatrix[3][2] = 0.f;
			scaleMatrix[3][3] = 1.0f;

			return mul(scaleMatrix, vertPos);
		}

		vertexOutput vert(vertexInput v)
		{
			vertexOutput o;
			o.pos = UnityObjectToClipPos(Outline(v.vertex, _Outline));
			return o;
		}

		half4 frag(vertexOutput i) : COLOR
		{
			return _OutlineColour;
		}

			ENDCG
		}

			Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
#pragma vertex vert
#pragma fragment frag

			uniform half4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		struct vertexInput
		{
			float4 vertex : POSITION;
			float4 textCoord : TEXCOORD0;
		};

		struct vertexOutput
		{
			float4 pos : SV_POSITION;
			float4 textCoord : TEXCOORD0;
		};

		vertexOutput vert(vertexInput v)
		{
			vertexOutput o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.textCoord.xy = (v.textCoord  * _MainTex_ST.xy + _MainTex_ST.zw);
			return o;
		}

		half4 frag(vertexOutput i) : COLOR
		{
			float4 mainTexCol = tex2D(_MainTex, i.textCoord.xy);
			return  mainTexCol * _Color;
		}

			ENDCG
		}
		}
}
