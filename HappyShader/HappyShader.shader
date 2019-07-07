Shader "Custom/HappyShader"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
		_Amplitude("Amplitude", Range(0, 10)) = 6
		_Speed("Speed", float) = 50
		_Compression("Compression Factor", float) = 25
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
			#define Deg2Rad 0.01745329

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

			uniform float4 _Color;
			uniform float  _Amplitude;
			uniform float  _Speed;
			uniform float  _Compression;

            v2f vert (appdata v)
            {
				float angle = sin(_Time * _Speed) * _Amplitude + 90;
				float rads = angle * Deg2Rad;
				float s = sign(angle);

				float horizontalOffset = cos(rads) * pow(v.vertex.y, 2);
				v.vertex.z += horizontalOffset;

				float verticalOffset = -abs(cos(rads)) * pow(v.vertex.y, 2) * (-v.vertex.z * s) * sign(angle - 90);
				verticalOffset -= _Compression * (1-sin(rads)) * v.vertex.y;
				v.vertex.y += verticalOffset;

				v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
                return col;
            }
            ENDCG
        }
    }
}
