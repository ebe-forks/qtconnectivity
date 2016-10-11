/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtBluetooth module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or (at your option) the GNU General
** Public license version 3 or any later version approved by the KDE Free
** Qt Foundation. The licenses are as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL2 and LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-2.0.html and
** https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef OSXBTLEDEVICEINQUIRY_P_H
#define OSXBTLEDEVICEINQUIRY_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#include "qbluetoothdevicediscoveryagent.h"
#include "qbluetoothdeviceinfo.h"
#include "osxbtutility_p.h"
#include "osxbluetooth_p.h"

#include <QtCore/qelapsedtimer.h>
#include <QtCore/qglobal.h>
#include <QtCore/qlist.h>

#include <Foundation/Foundation.h>

QT_BEGIN_NAMESPACE

class QBluetoothUuid;

namespace OSXBluetooth
{

class LECBManagerNotifier;

}

QT_END_NAMESPACE

// Ugly but all these QT_PREPEND_NAMESPACE etc. are even worse ...
using OSXBluetooth::LECBManagerNotifier;
using OSXBluetooth::ObjCScopedPointer;
using QT_PREPEND_NAMESPACE(QElapsedTimer);

enum LEInquiryState
{
    InquiryStarting,
    InquiryActive,
    InquiryFinished,
    InquiryCancelled,
    ErrorPoweredOff,
    ErrorLENotSupported
};

@interface QT_MANGLE_NAMESPACE(OSXBTLEDeviceInquiry) : NSObject
{
    LECBManagerNotifier *notifier;
    ObjCScopedPointer<NSMutableSet> uuids;
    ObjCScopedPointer<CBCentralManager> manager;

    QList<QBluetoothDeviceInfo> devices;
    LEInquiryState internalState;
    int inquiryTimeoutMS;

    // Timers to check if we can execute delayed callbacks:
    QT_PREPEND_NAMESPACE(QElapsedTimer) errorTimer;
    QT_PREPEND_NAMESPACE(QElapsedTimer) scanTimer;
}

- (id)initWithNotifier:(LECBManagerNotifier *)aNotifier;
- (void)dealloc;

// IMPORTANT: both 'startWithTimeout' and 'stop'
// can be executed only on the "Qt's LE queue".
- (void)startWithTimeout:(int)timeout;
- (void)stop;

@end

#endif
