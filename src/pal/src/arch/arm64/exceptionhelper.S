// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

#include "unixasmmacros.inc"
#include "asmconstants.h"

//////////////////////////////////////////////////////////////////////////
//
// This function creates a stack frame right below the target frame, restores all callee
// saved registers, SP, and LR from the passed in context.
// Then it uses the ThrowExceptionHelper to throw the passed in exception from that context.
// EXTERN_C void ThrowExceptionFromContextInternal(CONTEXT* context, PAL_SEHException* ex);
LEAF_ENTRY ThrowExceptionFromContextInternal, _TEXT
    // Save the FP & LR to the stack so that the unwind can work at the instruction after
    // loading the FP from the context, but before loading the SP from the context.
    stp fp, lr,  [sp, -16]!

    ldp x19,x20, [x0, #(CONTEXT_X19)]
    ldp x21,x22, [x0, #(CONTEXT_X21)]
    ldp x23,x24, [x0, #(CONTEXT_X23)]
    ldp x24,x25, [x0, #(CONTEXT_X24)]
    ldp x26,x27, [x0, #(CONTEXT_X26)]
    ldp x28,fp,  [x0, #(CONTEXT_X28)]
    ldr lr,      [x0, #(CONTEXT_Pc)]
    ldr x2,      [x0, #(CONTEXT_Sp)]
    mov sp, x2

    // The PAL_SEHException pointer
    mov x0, x1
    b   EXTERNAL_C_FUNC(ThrowExceptionHelper)
LEAF_END ThrowExceptionFromContextInternal, _TEXT
