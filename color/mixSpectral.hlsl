#include "luminance.hlsl"
#include "space/srgb2rgb.hlsl"
#include "space/rgb2srgb.hlsl"
#include "space/xyz2srgb.hlsl"

/*
contributors: Ronald van Wijnen (@OneDayOfCrypto)
description: | 
    Spectral mix allows you to achieve realistic color mixing in your projects. 
    It is based on the Kubelka-Munk theory, a proven scientific model that simulates 
    how light interacts with paint to produce lifelike color mixing. 
    Find more informatiom on Ronald van Wijnen's [original repository](https://github.com/rvanwijnen/spectral.js)
options:
    - MIXSPECTRAL_COLORSPACE_SRGB: by default colA and colB are linear RGB. If you want to use sRGB, define this flag.
use: <float3\float4> mixSpectral(<float3|float4> colorA, <float3|float4> colorB, float pct)
examples:
    - /shaders/color_mix.frag
license: license: MIT License Copyright (c) 2023 Ronald van Wijnen
*/

#ifndef FNC_MIXSPECTRA
#define FNC_MIXSPECTRA

const int MIXSPECTRA_SIZE = 37;

void mixSpectral_linear2reflectance(float3 lrgb, inout float R[MIXSPECTRA_SIZE]) {
     R[0] = dot(float3(0.03065266, 0.00488428, 0.96446343), lrgb);
     R[1] = dot(float3(0.03065266, 0.00488428, 0.96446661), lrgb);
     R[2] = dot(float3(0.03012503, 0.00489302, 0.96499804), lrgb);
     R[3] = dot(float3(0.02837440, 0.00505932, 0.96660443), lrgb);
     R[4] = dot(float3(0.02443079, 0.00552416, 0.97009698), lrgb);
     R[5] = dot(float3(0.01900359, 0.00668451, 0.97438902), lrgb);
     R[6] = dot(float3(0.01345743, 0.00966823, 0.97695626), lrgb);
     R[7] = dot(float3(0.00905147, 0.01843871, 0.97257598), lrgb);
     R[8] = dot(float3(0.00606943, 0.05369084, 0.94029002), lrgb);
     R[9] = dot(float3(0.00419240, 0.30997719, 0.68585683), lrgb);
    R[10] = dot(float3(0.00300621, 0.84166297, 0.15533920), lrgb);
    R[11] = dot(float3(0.00229452, 0.95140393, 0.04629964), lrgb);
    R[12] = dot(float3(0.00190474, 0.97711658, 0.02096763), lrgb);
    R[13] = dot(float3(0.00175435, 0.98538119, 0.01284767), lrgb);
    R[14] = dot(float3(0.00182349, 0.98819579, 0.00996131), lrgb);
    R[15] = dot(float3(0.00218287, 0.98842729, 0.00937163), lrgb);
    R[16] = dot(float3(0.00308472, 0.98651266, 0.01038752), lrgb);
    R[17] = dot(float3(0.00539517, 0.98125477, 0.01334010), lrgb);
    R[18] = dot(float3(0.01275154, 0.96796653, 0.01927821), lrgb);
    R[19] = dot(float3(0.04939664, 0.92126320, 0.02934328), lrgb);
    R[20] = dot(float3(0.41424516, 0.54678757, 0.03897609), lrgb);
    R[21] = dot(float3(0.89425217, 0.07097922, 0.03478168), lrgb);
    R[22] = dot(float3(0.95202201, 0.02151275, 0.02647979), lrgb);
    R[23] = dot(float3(0.96833286, 0.01120932, 0.02047109), lrgb);
    R[24] = dot(float3(0.97175685, 0.00778212, 0.02047109), lrgb);
    R[25] = dot(float3(0.97320302, 0.00633303, 0.02047109), lrgb);
    R[26] = dot(float3(0.97387285, 0.00566048, 0.02047109), lrgb);
    R[27] = dot(float3(0.97418395, 0.00534751, 0.02047109), lrgb);
    R[28] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[29] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[30] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[31] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[32] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[33] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[34] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[35] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
    R[36] = dot(float3(0.97432335, 0.00520568, 0.02047109), lrgb);
}

float3 mixSpectral_reflectance2xyz(float R[MIXSPECTRA_SIZE]) {
    float3 xyz = float3(0.0);
    xyz +=  R[0] * float3(0.00013656, 0.00001886, 0.00060998);
    xyz +=  R[1] * float3(0.00131637, 0.00018140, 0.00595953);
    xyz +=  R[2] * float3(0.00640948, 0.00080632, 0.02967913);
    xyz +=  R[3] * float3(0.01643026, 0.00203723, 0.07855475);
    xyz +=  R[4] * float3(0.02407799, 0.00344701, 0.11921905);
    xyz +=  R[5] * float3(0.03573573, 0.00662872, 0.18425721);
    xyz +=  R[6] * float3(0.03894236, 0.01029015, 0.21077492);
    xyz +=  R[7] * float3(0.03004572, 0.01410577, 0.17634280);
    xyz +=  R[8] * float3(0.01860940, 0.01944240, 0.12741269);
    xyz +=  R[9] * float3(0.00745020, 0.02631783, 0.07374910);
    xyz += R[10] * float3(0.00129006, 0.03273183, 0.03663768);
    xyz += R[11] * float3(0.00052314, 0.04424704, 0.01923495);
    xyz += R[12] * float3(0.00344737, 0.05701200, 0.00807728);
    xyz += R[13] * float3(0.01065677, 0.06907721, 0.00335702);
    xyz += R[14] * float3(0.02169564, 0.08047999, 0.00140323);
    xyz += R[15] * float3(0.03395004, 0.08541136, 0.00053757);
    xyz += R[16] * float3(0.04732762, 0.08725039, 0.00020463);
    xyz += R[17] * float3(0.06029657, 0.08416902, 0.00007431);
    xyz += R[18] * float3(0.07284094, 0.07860677, 0.00002725);
    xyz += R[19] * float3(0.08385845, 0.07114656, 0.00001053);
    xyz += R[20] * float3(0.08612109, 0.05907490, 0.00000391);
    xyz += R[21] * float3(0.08746894, 0.05050107, 0.00000166);
    xyz += R[22] * float3(0.07951403, 0.04005938, 0.00000072);
    xyz += R[23] * float3(0.06405614, 0.02932589, 0.00000000);
    xyz += R[24] * float3(0.04521591, 0.01939909, 0.00000000);
    xyz += R[25] * float3(0.03062648, 0.01258803, 0.00000000);
    xyz += R[26] * float3(0.01838938, 0.00734245, 0.00000000);
    xyz += R[27] * float3(0.01044320, 0.00409671, 0.00000000);
    xyz += R[28] * float3(0.00576692, 0.00223674, 0.00000000);
    xyz += R[29] * float3(0.00279715, 0.00107927, 0.00000000);
    xyz += R[30] * float3(0.00119535, 0.00046015, 0.00000000);
    xyz += R[31] * float3(0.00059496, 0.00022887, 0.00000000);
    xyz += R[32] * float3(0.00029365, 0.00011300, 0.00000000);
    xyz += R[33] * float3(0.00011500, 0.00004432, 0.00000000);
    xyz += R[34] * float3(0.00006279, 0.00002425, 0.00000000);
    xyz += R[35] * float3(0.00003275, 0.00001268, 0.00000000);
    xyz += R[36] * float3(0.00001376, 0.00000535, 0.00000000);
    return xyz;
}

float3 mixSpectral(float3 colA, float3 colB, float t) {
    #ifdef MIXSPECTRAL_COLORSPACE_SRGB
    float3 lrgb1 = srgb2rgb(colA);
    float3 lrgb2 = srgb2rgb(colB);
    #else
    float3 lrgb1 = colA;
    float3 lrgb2 = colB;
    #endif

    // Linear luminance to concentration
    float t1 = luminance(lrgb1) * pow(1.0 - t, 2.0);
    float t2 = luminance(lrgb2) * pow(t, 2.0);
    t = t2 / (t1 + t2);

    float R1[MIXSPECTRA_SIZE];
    float R2[MIXSPECTRA_SIZE];
    mixSpectral_linear2reflectance(lrgb1, R1);
    mixSpectral_linear2reflectance(lrgb2, R2);

    float R[MIXSPECTRA_SIZE];
    for (int i = 0; i < MIXSPECTRA_SIZE; i++) {
      float KS = 0.0;
      KS += (1.0 - t) * (pow(1.0 - R1[i], 2.0) / (2.0 * R1[i]));
      KS += t * (pow(1.0 - R2[i], 2.0) / (2.0 * R2[i]));
      float KM = 1.0 + KS - sqrt(pow(KS, 2.0) + 2.0 * KS);
      //Saunderson correction
      R[i] = KM;
    }
    float3 srgb = xyz2srgb(mixSpectral_reflectance2xyz(R));
    #ifdef MIXSPECTRAL_COLORSPACE_SRGB
    return srgb;
    #else
    return srgb2rgb(srgb);
    #endif
}

float4 mixSpectral( float4 colA, float4 colB, float h ) {
    return float4( mixSpectral(colA.rgb, colB.rgb, h), lerp(colA.a, colB.a, h) );
}
#endif