// Upgrade NOTE: commented out 'float4x4 _World2Object', a built-in variable

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4x4 _Object2World', a built-in variable
// Upgrade NOTE: commented out 'float4x4 _World2Object', a built-in variable

Shader "Custom/ambient"
{   
    Properties
    {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Pass
        {
            Tags{ "LightMode" = "ForwardBase" } //zorgt ervoor dat de light direction live update
            CGPROGRAM
            #pragma vertex vertexFunc
            #pragma fragment fragmentFunc

            uniform float4 _Color;

            //unity variables
            uniform float4 _LightColor0;
            // float4x4 _Object2World; //convert vertex to world space
            // float4x4 _World2Object; //convert vertex to object space
            // float4 _WorldSpaceLightPos0; //position of light in world space

            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 col : COLOR;
            };

            vertexOutput vertexFunc(vertexInput vi)
            {
                vertexOutput vo;
                
                float3 normalDirection = normalize(mul(float4(vi.normal, 0.0), unity_WorldToObject).xyz); //world2object = float4 daarom = normal gecast naar float4 en dan worden alleen de xyz gegevens gebruikt omdat normaldir = float3
                float3 lightDirection;
                float atten = 1.0;

                lightDirection = normalize(_WorldSpaceLightPos0.xyz);

                float3 diffuseReflection = atten * _LightColor0.xyz * max( 0.0, dot(normalDirection, lightDirection)); //dotproduct //max verwijderd alle waardes onder 0
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT; //het zelfde als lambert maar dan met deze lijn extra 
                
                vo.col = float4(diffuseReflection * _Color.rgb, 1.0);
                vo.pos = UnityObjectToClipPos(vi.vertex);
                
                return vo;
            }

            float4 fragmentFunc(vertexOutput vo) : COLOR
            {
                return vo.col;
            }
            
            ENDCG
        }
    }
}
