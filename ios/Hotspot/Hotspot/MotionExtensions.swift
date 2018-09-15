//
//  InverseExtension.swift
//  Hotspot
//
//  Created by Gokul Swamy on 9/15/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import CoreMotion
import GLKit

extension CMDeviceMotion {
    
    func userAccelerationInReferenceFrame() -> CMAcceleration {
        
        let origin = userAcceleration
        let rotation = attitude.rotationMatrix
        let matrix = rotation.inverse()
        
        var result = CMAcceleration()
        result.x = origin.x * matrix.m11 + origin.y * matrix.m12 + origin.z * matrix.m13;
        result.y = origin.x * matrix.m21 + origin.y * matrix.m22 + origin.z * matrix.m23;
        result.z = origin.x * matrix.m31 + origin.y * matrix.m32 + origin.z * matrix.m33;
        
        return result
    }
    
    func gravityInReferenceFrame() -> CMAcceleration {
        
        let origin = self.gravity
        let rotation = attitude.rotationMatrix
        let matrix = rotation.inverse()
        
        var result = CMAcceleration()
        result.x = origin.x * matrix.m11 + origin.y * matrix.m12 + origin.z * matrix.m13;
        result.y = origin.x * matrix.m21 + origin.y * matrix.m22 + origin.z * matrix.m23;
        result.z = origin.x * matrix.m31 + origin.y * matrix.m32 + origin.z * matrix.m33;
        
        return result
    }
}

extension CMRotationMatrix {
    
    func inverse() -> CMRotationMatrix {
        
        let matrix = GLKMatrix3Make(Float(m11), Float(m12), Float(m13), Float(m21), Float(m22), Float(m23), Float(m31), Float(m32), Float(m33))
        let invert = GLKMatrix3Invert(matrix, nil)
        
        return CMRotationMatrix(m11: Double(invert.m00), m12: Double(invert.m01), m13: Double(invert.m02),
                                m21: Double(invert.m10), m22: Double(invert.m11), m23: Double(invert.m12),
                                m31: Double(invert.m20), m32: Double(invert.m21), m33: Double(invert.m22))
        
    }
    
}
