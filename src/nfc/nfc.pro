TARGET = QtNfc
QT = core

load(qt_module)

QMAKE_DOCS = $$PWD/doc/qtnfc.qdocconf
OTHER_FILES += doc/src/*.qdoc   # show .qdoc files in Qt Creator

PUBLIC_HEADERS += \
    qnfcglobal.h \
    qnearfieldmanager.h \
    qnearfieldtarget.h \
    qndefrecord.h \
    qndefnfctextrecord.h \
    qndefmessage.h \
    qndeffilter.h \
    qndefnfcurirecord.h \
    qqmlndefrecord.h \
    qndefnfcsmartposterrecord.h \
    qnearfieldsharemanager.h \
    qnearfieldsharetarget.h

PRIVATE_HEADERS += \
    qllcpsocket_p.h \
    qllcpserver_p.h \
    qndefrecord_p.h \
    qnearfieldtarget_p.h \
    qnearfieldmanager_p.h \
    qnearfieldtagtype1_p.h \
    qnearfieldtagtype2_p.h \
    qnearfieldtagtype3_p.h \
    qnearfieldtagtype4_p.h \
    qtlv_p.h \
    qndefnfcsmartposterrecord_p.h \
    qnearfieldsharemanager_p.h \
    qnearfieldsharetarget_p.h

SOURCES += \
    qnearfieldmanager.cpp \
    qnearfieldtarget.cpp \
    qndefrecord.cpp \
    qndefnfctextrecord.cpp \
    qndefmessage.cpp \
    qndeffilter.cpp \
    qndefnfcurirecord.cpp \
    qnearfieldtagtype1.cpp \
    qnearfieldtagtype2.cpp \
    qnearfieldtagtype3.cpp \
    qllcpsocket.cpp \
    qnearfieldtagtype4.cpp \
    qtlv.cpp \
    qllcpserver.cpp \
    qqmlndefrecord.cpp \
    qndefnfcsmartposterrecord.cpp \
    qnearfieldsharemanager.cpp \
    qnearfieldsharetarget.cpp \
    qnfc.cpp

CONFIG(blackberry) {
    NFC_BACKEND_AVAILABLE = yes
    DEFINES += QNX_NFC #QQNXNFC_DEBUG

    LIBS += -lnfc

    PRIVATE_HEADERS += \
        qllcpserver_qnx_p.h \
        qllcpsocket_qnx_p.h \
        qnearfieldmanager_qnx_p.h \
        qnx/qnxnfcmanager_p.h \
        qnearfieldtarget_qnx_p.h \
        qnx/qnxnfceventfilter_p.h

    SOURCES += \
        qllcpserver_qnx_p.cpp \
        qllcpsocket_qnx_p.cpp \
        qnearfieldmanager_qnx.cpp \
        qnx/qnxnfcmanager.cpp \
        qnx/qnxnfceventfilter.cpp

    config_libbb2 {
        SOURCES += \
            qnearfieldsharemanager_qnx_p.cpp \
            qnearfieldsharetarget_qnx_p.cpp \
            qnx/qnxnfcsharemanager_p.cpp

        PRIVATE_HEADERS += \
            qnearfieldsharemanager_qnx_p.h \
            qnearfieldsharetarget_qnx_p.h \
            qnx/qnxnfcsharemanager_p.h

        LIBS += -l:libbbsystem.so.2
    } else {
        SOURCES += \
            qnearfieldsharemanagerimpl_p.cpp \
            qnearfieldsharetargetimpl_p.cpp

        PRIVATE_HEADERS += \
            qnearfieldsharemanagerimpl_p.h \
            qnearfieldsharetargetimpl_p.h
    }

} else:linux:!android:qtHaveModule(dbus) {
    NFC_BACKEND_AVAILABLE = yes

    QT += dbus

    DEFINES += NEARD_NFC

    PRIVATE_HEADERS += \
        qllcpsocket_p_p.h \
        qllcpserver_p_p.h \
        qnearfieldmanager_neard_p.h \
        qnearfieldsharemanagerimpl_p.h \
        qnearfieldsharetargetimpl_p.h \
        qnearfieldtarget_neard_p.h

    SOURCES += \
        qllcpsocket_p.cpp \
        qllcpserver_p.cpp \
        qnearfieldsharemanagerimpl_p.cpp \
        qnearfieldsharetargetimpl_p.cpp \
        qnearfieldmanager_neard.cpp

    include(neard/neard.pri)

} else:simulator {
    NFC_BACKEND_AVAILABLE = yes

    QT *= gui

    PRIVATE_HEADERS += \
        qnearfieldmanagervirtualbase_p.h \
        qnearfieldmanager_simulator_p.h \
        qllcpsocket_simulator_p.h \
        qllcpserver_simulator_p.h \
        qnearfieldsharemanagerimpl_p.h \
        qnearfieldsharetargetimpl_p.h


    SOURCES += \
        qnearfieldmanagervirtualbase.cpp \
        qnearfieldmanager_simulator.cpp \
        qllcpsocket_simulator_p.cpp \
        qllcpserver_simulator_p.cpp \
        qnearfieldsharemanagerimpl_p.cpp \
        qnearfieldsharetargetimpl_p.cpp
} else:android:!android-no-sdk {
    NFC_BACKEND_AVAILABLE = yes
    ANDROID_PERMISSIONS = \
        android.permission.NFC
    ANDROID_BUNDLED_JAR_DEPENDENCIES = \
        jar/QtNfc-bundled.jar:org.qtproject.qt5.android.nfc.QtNfc
    ANDROID_JAR_DEPENDENCIES = \
        jar/QtNfc.jar:org.qtproject.qt5.android.nfc.QtNfc
    DEFINES += ANDROID_NFC
    QT += core-private

    PRIVATE_HEADERS += \
        qllcpserver_android_p.h \
        qllcpsocket_android_p.h \
        android/androidjninfc_p.h \
        qnearfieldmanager_android_p.h \
        qnearfieldtarget_android_p.h \
        qnearfieldsharemanagerimpl_p.h \
        qnearfieldsharetargetimpl_p.h \
        android/androidmainnewintentlistener_p.h


    SOURCES += \
        qllcpserver_android_p.cpp \
        qllcpsocket_android_p.cpp \
        android/androidjninfc.cpp \
        qnearfieldmanager_android.cpp \
        qnearfieldtarget_android.cpp \
        qnearfieldsharemanagerimpl_p.cpp \
        qnearfieldsharetargetimpl_p.cpp \
        android/androidmainnewintentlistener.cpp
}

isEmpty(NFC_BACKEND_AVAILABLE) {
    message("Unsupported NFC platform, will not build a working QtNfc library.")

    PRIVATE_HEADERS += \
        qllcpsocket_p_p.h \
        qllcpserver_p_p.h \
        qnearfieldmanagerimpl_p.h \
        qnearfieldsharemanagerimpl_p.h \
        qnearfieldsharetargetimpl_p.h

    SOURCES += \
        qllcpsocket_p.cpp \
        qllcpserver_p.cpp \
        qnearfieldmanagerimpl_p.cpp \
        qnearfieldsharemanagerimpl_p.cpp \
        qnearfieldsharetargetimpl_p.cpp
}

HEADERS += $$PUBLIC_HEADERS $$PRIVATE_HEADERS
