//
//  Shaders.metal
//  gol
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright (c) 2015 Max Bilbow. All rights reserved.
//

#include <metal_stdlib>

using namespace metal;

//struct VertexInOut
//{
//    float4  position [[position]];
//    float4  color;
//};
//
//vertex VertexInOut passThroughVertex(uint vid [[ vertex_id ]],
//                                     constant packed_float4* position  [[ buffer(0) ]],
//                                     constant packed_float4* color    [[ buffer(1) ]])
//{
//    VertexInOut outVertex;
//    
//    outVertex.position = position[vid];
//    outVertex.color    = color[vid];
//    
//    return outVertex;
//};
//
//fragment half4 passThroughFragment(VertexInOut inFrag [[stage_in]])
//{
//    return half4(inFrag.color);
//};
//
//

struct VertexIn{
    packed_float3 position;
    packed_float4 color;
};

struct VertexOut{
    float4 position [[position]];  //1
    float4 color;
};

struct Uniforms{
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut basic_vertex(
                              const device VertexIn* vertex_array [[ buffer(0) ]],
                              const device Uniforms&  uniforms    [[ buffer(1) ]],           //1
                              unsigned int vid [[ vertex_id ]]) {
    
    float4x4 mv_Matrix = uniforms.modelMatrix;                     //2
    float4x4 proj_Matrix = uniforms.projectionMatrix;
    
    VertexIn VertexIn = vertex_array[vid];
    
    VertexOut VertexOut;
    VertexOut.position = proj_Matrix * mv_Matrix * float4(VertexIn.position,1);  //3
    VertexOut.color = VertexIn.color;
    
    return VertexOut;
}

fragment half4 basic_fragment(VertexOut interpolated [[stage_in]]) {  //1
    return half4(interpolated.color[0], interpolated.color[1], interpolated.color[2], interpolated.color[3]); //2
}
