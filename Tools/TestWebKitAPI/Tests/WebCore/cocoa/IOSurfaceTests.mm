/*
 * Copyright (C) 2021 Apple Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "config.h"

#import "Test.h"
#import <WebCore/IOSurface.h>
#import <wtf/MachSendRight.h>

namespace TestWebKitAPI {

TEST(IOSurfaceTest, IsInUse)
{
    auto s1 = WebCore::IOSurface::create(nullptr, { 5, 5 }, WebCore::DestinationColorSpace::SRGB()); 
    EXPECT_FALSE(s1->isInUse());
    auto sendRight1 = s1->createSendRight();
    EXPECT_TRUE(s1->isInUse());
    auto sendRight2 = s1->createSendRight();
    sendRight1 = { };
    EXPECT_TRUE(s1->isInUse());
    sendRight2 = { };
    EXPECT_FALSE(s1->isInUse());
}

TEST(IOSurfaceTest, CreatePlatformContext)
{
    auto s1 = WebCore::IOSurface::create(nullptr, { 5, 5 }, WebCore::DestinationColorSpace::SRGB()); 
    EXPECT_FALSE(s1->isInUse());
    auto c1 = s1->createPlatformContext();
    auto c2 = s1->createPlatformContext();
    EXPECT_NE(c1, c2);
    EXPECT_FALSE(s1->isInUse());
    c1 = nullptr;
    EXPECT_FALSE(s1->isInUse());
    c2 = nullptr;
    EXPECT_FALSE(s1->isInUse());
}

}
