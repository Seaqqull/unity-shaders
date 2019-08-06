Shader "Custom/Lighting/Phong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularColor ("Specular color", Color) = (1,1,1,1)
        _SpecularPower ("Specular power", Range(0, 50)) = 10.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        float4 _SpecularColor;
        float _SpecularPower;
        sampler2D _MainTex;
        float4 _Color;
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Phong

        fixed4 LightingPhong(SurfaceOutput o, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            // Reflection
            float Ndot = dot(o.Normal, lightDir);
            float3 reflection = normalize(2.0 * o.Normal * Ndot - lightDir);

            // Specular
            float specular = _SpecularColor.rgb * 
                pow(max(0, dot(reflection, viewDir)), _SpecularPower);
            
            fixed4 c;
            c.rgb = (o.Albedo * _LightColor0.rgb * max(0, Ndot) * atten) +
                (_LightColor0.rgb * specular);
            c.a = o.Alpha;

            return c;
        }
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };        

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
