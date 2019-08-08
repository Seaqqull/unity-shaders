Shader "Custom/Surface/Normal"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _NormalTex ("Normal map", 2D) = "bump" {}
        _NormalMapIntensity("Normal intensity", Range(0,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        // Lambert based lighting model, and enable shadows on all light types
        #pragma surface surf Lambert fullforwardshadows

         
        #pragma target 3.0
        
        struct Input
        {
            float2 uv_NormalTex;
        };
        
        fixed4 _Color;
        sampler2D _NormalTex;
        float _NormalMapIntensity;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
 
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            
            normalMap.x *= _NormalMapIntensity;
            normalMap.y *= _NormalMapIntensity;
            o.Normal = normalMap.rgb;

            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
