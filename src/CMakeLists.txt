cmake_minimum_required(VERSION 3.16)

set(HUSKARUI_VERSION 0.5.0.0)

message(STATUS "Configuring HuskarUIBasic Version: ${HUSKARUI_VERSION}")

project(HuskarUIBasic VERSION ${HUSKARUI_VERSION} LANGUAGES CXX)

#Add HuskarUIHelper
include(${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/HuskarUIHelper.cmake)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.5 COMPONENTS Quick QuickTemplates2 ShaderTools Multimedia REQUIRED)
qt_standard_project_setup(REQUIRES 6.5)

#Set header output dir.
if(NOT HUSKARUI_HEADER_OUTPUT_DIRECTORY)
    if(BUILD_HUSKARUI_IN_DEFAULT_LOCATION)
        set(HUSKARUI_HEADER_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../include/HuskarUI)
    else()
        set(HUSKARUI_HEADER_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/HuskarUI/include)
    endif()
endif()

#Set library output dir.
if(NOT HUSKARUI_LIBRARY_OUTPUT_DIRECTORY)
    if(BUILD_HUSKARUI_IN_DEFAULT_LOCATION)
        set(HUSKARUI_LIBRARY_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../)
        if(BUILD_HUSKARUI_STATIC_LIBRARY)
            set(HUSKARUI_LIBRARY_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../)
        endif()
    else()
        set(HUSKARUI_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/HuskarUI/lib)
    endif()
endif()

#Set plugin output dir.
if(NOT HUSKARUI_PLUGIN_OUTPUT_DIRECTORY)
    if(BUILD_HUSKARUI_IN_DEFAULT_LOCATION)
        set(HUSKARUI_PLUGIN_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../qml/HuskarUI/Basic)
    else()
        set(HUSKARUI_PLUGIN_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/HuskarUI/plugins/HuskarUI/Basic)
    endif()
endif()

message(STATUS "The HuskarUI header output dir: ${HUSKARUI_HEADER_OUTPUT_DIRECTORY}")
message(STATUS "The HuskarUI library output dir: ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}")
message(STATUS "The HuskarUI plugin output dir: ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}")

if(BUILD_HUSKARUI_STATIC_LIBRARY)
    set(PLUGIN_NAME HuskarUIBasicPlugin)
    qt_add_library(${PROJECT_NAME} STATIC)
else()
    set(PLUGIN_NAME huskaruibasicplugin)
    qt_add_library(${PROJECT_NAME} SHARED)
endif()

#Default is desktop platform
if(NOT DEFINED BUILD_HUSKARUI_ON_DESKTOP_PLATFORM)
    set(BUILD_HUSKARUI_ON_DESKTOP_PLATFORM ON)
endif()

#Add windows RC
set(HUSKARUI_RC_FILE "")
if(WIN32)
    set(HUSKARUI_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    set(RC_NAME "")
    if(BUILD_HUSKARUI_STATIC_LIBRARY)
        set(RC_NAME "${PROJECT_NAME}.lib")
    else()
        set(RC_NAME "${PROJECT_NAME}.dll")
    endif()
    hus_add_win_rc(${PROJECT_NAME}
        COMMENTS "Modern UI-Kit for Qml { Design reference Ant-d }"
        NAME ${RC_NAME}
        COMPANY "HuskarUI"
        DESCRIPTION "https://github.com/davidhsing/HuskarUI"
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2025 davidhsing. All rights reserved."
        OUTPUT_FILE "${HUSKARUI_RC_FILE}"
    )
endif()

if(QT_KNOWN_POLICY_QTP0004)
    qt_policy(SET QTP0004 NEW)
endif()

qt_add_qml_module(${PROJECT_NAME}
    URI "HuskarUI.Basic"
    VERSION 1.0
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_NAME}
    #NO_GENERATE_PLUGIN_SOURCE
    RESOURCE_PREFIX "/"
    TYPEINFO "plugins.qmltypes"
    OUTPUT_DIRECTORY ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY}
    QML_FILES
        imports/HusButton.qml imports/HusButtonBlock.qml
        imports/HusIconButton.qml
        imports/HusCaptionButton.qml
        imports/HusTourFocus.qml imports/HusTourStep.qml
        imports/HusIconText.qml
        imports/HusCopyableText.qml
        imports/HusCaptionBar.qml
        imports/HusWindow.qml
        imports/HusMenu.qml
        imports/HusDivider.qml
        imports/HusFormItem.qml
        imports/HusGroupBox.qml
        imports/HusEmpty.qml
        imports/HusShield.qml
        imports/HusSwitch.qml
        imports/HusScrollBar.qml
        imports/HusMouseMoveArea.qml
        imports/HusMouseResizeArea.qml
        imports/HusAcrylic.qml
        imports/HusSlider.qml
        imports/HusTabs.qml
        imports/HusToolTip.qml
        imports/HusSelect.qml
        imports/HusInput.qml
        imports/HusInputInteger.qml
        imports/HusInputNumber.qml
        imports/HusInputOnce.qml
        imports/HusRate.qml
        imports/HusRadio.qml imports/HusRadioBlock.qml
        imports/HusCheckBox.qml
        imports/HusDrawer.qml
        imports/HusCollapse.qml
        imports/HusAvatar.qml
        imports/HusCard.qml
        imports/HusPagination.qml
        imports/HusPopup.qml
        imports/HusTimeline.qml
        imports/HusTag.qml
        imports/HusTable.qml
        imports/HusMessage.qml
        imports/HusAutoComplete.qml
        imports/HusText.qml
        imports/HusProgress.qml
        imports/HusBadge.qml
        imports/HusCarousel.qml
        imports/HusSwitchEffect.qml
        imports/HusContextMenu.qml
        imports/HusBreadcrumb.qml
        imports/HusImage.qml
        imports/HusImagePreview.qml
        imports/HusMultiSelect.qml
        imports/HusDateTimePicker.qml
        imports/HusShadow.qml
        imports/HusNotification.qml
        imports/HusPopconfirm.qml
        imports/HusPopover.qml
        imports/HusModal.qml
        imports/HusFileBrowser.qml
        imports/HusSpin.qml
        imports/HusStatusBar.qml
        imports/HusTextArea.qml
        imports/HusCheckerBoard.qml
        imports/HusColorPicker.qml imports/HusColorPickerPanel.qml
        imports/HusAudioDiagnosis.qml
        imports/HusMaskOverlay.qml
    SOURCES
        $<$<BOOL:${WIN32}>:${HUSKARUI_RC_FILE}>
        cpp/husglobal.h
        cpp/husdefinitions.h
        #cpp/huskaruiplugin.cpp
        cpp/husapp.h cpp/husapp.cpp
        cpp/theme/hustheme.h cpp/theme/hustheme.cpp cpp/theme/hustheme_p.h
        cpp/theme/husthemefunctions.h cpp/theme/husthemefunctions.cpp
        cpp/theme/huscolorgenerator.h cpp/theme/huscolorgenerator.cpp
        cpp/theme/hussizegenerator.h cpp/theme/hussizegenerator.cpp
        cpp/theme/husradiusgenerator.h cpp/theme/husradiusgenerator.cpp
        cpp/theme/hussystemthemehelper.h cpp/theme/hussystemthemehelper.cpp
        cpp/utils/husapi.h cpp/utils/husapi.cpp
        cpp/utils/husasynchasher.h cpp/utils/husasynchasher.cpp
        cpp/controls/husiconfont.h cpp/controls/husiconfont.cpp
        cpp/controls/husrectangle.h cpp/controls/husrectangle.cpp
        cpp/controls/huswatermark.h cpp/controls/huswatermark.cpp
        cpp/controls/huswindowagent.h cpp/controls/huswindowagent.cpp
        # QR-Code-generator
        cpp/controls/husqrcode.h cpp/controls/husqrcode.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/QR-Code-generator/cpp/qrcodegen.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/QR-Code-generator/cpp/qrcodegen.cpp
        # Multimedia
        cpp/controls/husaudioprobe.h cpp/controls/husaudioprobe.cpp
)

qt_add_resources(${PROJECT_NAME} "theme"
    PREFIX "/HuskarUI"
    FILES
        theme/Index.json
        theme/HusButton.json
        theme/HusCaptionButton.json
        theme/HusTour.json
        theme/HusIconText.json
        theme/HusCopyableText.json
        theme/HusMenu.json
        theme/HusDivider.json
        theme/HusFormItem.json
        theme/HusGroupBox.json
        theme/HusEmpty.json
        theme/HusShield.json
        theme/HusSwitch.json
        theme/HusScrollBar.json
        theme/HusSlider.json
        theme/HusTabs.json
        theme/HusToolTip.json
        theme/HusSelect.json
        theme/HusMultiSelect.json
        theme/HusInput.json
        theme/HusInputInteger.json
        theme/HusInputNumber.json
        theme/HusRate.json
        theme/HusRadio.json
        theme/HusRadioBlock.json
        theme/HusCheckBox.json
        theme/HusDrawer.json
        theme/HusCollapse.json
        theme/HusCard.json
        theme/HusPagination.json
        theme/HusPopup.json
        theme/HusTimeline.json
        theme/HusTag.json
        theme/HusTable.json
        theme/HusMessage.json
        theme/HusAutoComplete.json
        theme/HusProgress.json
        theme/HusCarousel.json
        theme/HusBreadcrumb.json
        theme/HusImage.json
        theme/HusDateTimePicker.json
        theme/HusNotification.json
        theme/HusPopconfirm.json
        theme/HusPopover.json
        theme/HusModal.json
        theme/HusSpin.json
        theme/HusStatusBar.json
        theme/HusTextArea.json
        theme/HusColorPicker.json
        theme/HusAudioDiagnosis.json
        theme/HusMaskOverlay.json
)

qt_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/HuskarUI"
    FILES
        resources/images/empty-default.svg
        resources/images/empty-simple.svg
        resources/images/hblinds.png
        resources/images/heart.png
        resources/images/smoke.png
        resources/images/star.png
        resources/images/stripes.png
        resources/font/HuskarUI-Icons.ttf
)

qt_add_shaders(${PROJECT_NAME} "shaders"
    PREFIX "/HuskarUI"
    FILES
        shaders/husrate.frag
)

# HuskarUI library output dir
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/bin
    LIBRARY_OUTPUT_DIRECTORY ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/lib
    ARCHIVE_OUTPUT_DIRECTORY ${HUSKARUI_LIBRARY_OUTPUT_DIRECTORY}/lib
)

if(MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wa,-mbig-obj)
elseif(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
    target_compile_options(${PROJECT_NAME} PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/utf-8;/Zi>)
endif()

target_compile_definitions(${PROJECT_NAME} PRIVATE
    BUILD_HUSKARUI_LIB
    HUSKARUI_LIBRARY_VERSION="${HUSKARUI_VERSION}"
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
    $<$<BOOL:${BUILD_HUSKARUI_STATIC_LIBRARY}>:BUILD_HUSKARUI_STATIC_LIBRARY>
    $<$<BOOL:${BUILD_HUSKARUI_ON_DESKTOP_PLATFORM}>:BUILD_HUSKARUI_ON_DESKTOP_PLATFORM>
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickPrivate
    Qt6::QuickTemplates2Private
    Qt6::Multimedia
    $<$<BOOL:${BUILD_HUSKARUI_ON_DESKTOP_PLATFORM}>:QWKCore>
    $<$<BOOL:${BUILD_HUSKARUI_ON_DESKTOP_PLATFORM}>:QWKQuick>
)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/theme
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/controls
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/utils
)

#Gen HuskarUI/include
if(HUSKARUI_HEADER_OUTPUT_DIRECTORY)
    file(COPY cpp/husglobal.h cpp/husapp.h cpp/husdefinitions.h cpp/controls cpp/theme cpp/utils
         DESTINATION ${HUSKARUI_HEADER_OUTPUT_DIRECTORY}
         FILES_MATCHING PATTERN "*.h"
         PATTERN "*_p.h" EXCLUDE)
endif()

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/HuskarUI/bin
    ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/HuskarUI/lib
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/HuskarUI/lib
)

install(
    FILES cpp/husglobal.h cpp/husapp.h cpp/husdefinitions.h
    DESTINATION ${CMAKE_INSTALL_PREFIX}/HuskarUI/include
)

install(
    DIRECTORY cpp/controls cpp/theme cpp/utils
    DESTINATION ${CMAKE_INSTALL_PREFIX}/HuskarUI/include
    FILES_MATCHING PATTERN "*.h"
    PATTERN "*_p.h" EXCLUDE
)

install(
    DIRECTORY ${HUSKARUI_PLUGIN_OUTPUT_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/HuskarUI/imports/HuskarUI
)
