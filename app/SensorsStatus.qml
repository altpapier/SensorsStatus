import QtQuick 2.2
import Ubuntu.Components 1.1
import QtPositioning 5.2
import QtSensors 5.2

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "sensorsstatus.chris"
    automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    function printablePositionMethod(method) {
        var out = "Unknown position method";
        if (method === PositionSource.SatellitePositioningMethod) out = "Satellite";
        else if (method === PositionSource.NoPositioningMethod) out = "Not available";
        else if (method === PositionSource.NonSatellitePositioningMethod) out = "Non-satellite";
        else if (method === PositionSource.AllPositioningMethods) out = "All/multiple";
        return out;
    }

    function printableSourceError(method) {
        var out = "Unknown source error";
        if (method === PositionSource.AccessError) out = "Access error";
        else if (method === PositionSource.ClosedError) out = "Closed error";
        else if (method === PositionSource.NoError) out = "No error";
        else if (method === PositionSource.UnknownSourceError) out = "Unidentified source error";
        else if (method === PositionSource.SocketError) out = "Socket error";
        return out;
    }

    PageStack {
        id: pageStack
        Component.onCompleted: push(tabs)

        Tabs {
            id: tabs

            Tab {
                title: i18n.tr('Accelerometer')
                page: Page {
                    id: accelerometerPage
                    NoData {
                        visible: !accelerometer.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: !!accelerometer.connectedToBackend
                        Accelerometer {
                            id: accelerometer
                            active: true
                        }
                        RowField {
                            title: i18n.tr('x (m/s/s)')
                            text: accelerometer.reading != null ? accelerometer.reading.x : '-'
                        }
                        RowField {
                            title: i18n.tr('y (m/s/s)')
                            text: accelerometer.reading != null ? accelerometer.reading.y : '-'
                        }
                        RowField {
                            title: i18n.tr('z (m/s/s)')
                            text: accelerometer.reading != null ? accelerometer.reading.z : '-'
                        }
                    }
                }
            }

            Tab {
                title: i18n.tr('Altimeter')
                page: Page {
                    id: altimeterPage
                    NoData {
                        visible: !altimeter.connectedToBackend
                    }


                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: !!altimeter.connectedToBackend

                        Altimeter {
                            id: altimeter
                            active: true
                        }
                        RowField {
                            title: i18n.tr('altitude (m)')
                            text: altimeter.reading != null ? altimeter.reading.altitude : '—'
                        }
                    }
                }
            }

            Tab {
                title: i18n.tr('Compass')
                page: Page {
                    id: compassPage
                    NoData {
                        visible: !compass.connectedToBackend
                    }


                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: !!compass.connectedToBackend

                        Compass {
                            id: compass
                            active: true
                        }
                        RowField {
                            title: i18n.tr('azimuth (º)')
                            text: compass.reading != null ? compass.reading.azimuth : '—'
                        }
                        RowField {
                            title: i18n.tr('calibration level')
                            text: compass.reading != null ? compass.reading.calibrationLevel : '—'
                        }
                    }
                }
            }

            Tab {
                title: i18n.tr("GPS")
                page: Page {
                    id: gpsPage

                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }

                        Row {
                            width: parent.width
                            spacing: units.gu(1)
                            anchors.margins: units.gu(0.5)

                            Label {
                                text: i18n.tr('Found supported backend')
                                anchors.verticalCenter: backendFound.verticalCenter
                            }

                            CheckBox {
                                id: backendFound
                                checked: geoposition.valid
                                enabled: false
                            }
                        }

                        Row {
                            width: parent.width
                            spacing: units.gu(1)
                            anchors.margins: units.gu(0.5)

                            Label {
                                text: i18n.tr('Active')
                                anchors.verticalCenter: backendActive.verticalCenter
                            }

                            CheckBox {
                                id: backendActive
                                checked: geoposition.active
                                enabled: false
                            }
                        }

                        RowField {
                            title: i18n.tr('Source status')
                            text: printableSourceError(geoposition.sourceError)
                        }

                        RowField {
                            title: i18n.tr('Name')
                            text: geoposition.name
                        }

                        RowField {
                            title: i18n.tr('Method')
                            text: printablePositionMethod(geoposition.positioningMethod)
                        }

                        RowField {
                            title: i18n.tr('Latitude (º)')
                            text: geoposition.position.coordinate.latitude || '—'
                        }

                        RowField {
                            title: i18n.tr('Longitude (º)')
                            text: geoposition.position.coordinate.longitude || '—'
                        }

                        RowField {
                            title: i18n.tr('Horizontal accuracy (m)')
                            text: geoposition.position.horizontalAccuracy || '—'
                        }

                        RowField {
                            title: i18n.tr('Altitude (m)')
                            text: geoposition.position.coordinate.altitude || '—'
                        }

                        RowField {
                            title: i18n.tr('Vertical accuracy (m)')
                            text: geoposition.position.verticalAccuracy || '—'
                        }

                        RowField {
                            title: i18n.tr('Speed (m/s)')
                            text: geoposition.position.speed === -1 ? '—' : geoposition.position.speed
                        }

                        RowField {
                            title: i18n.tr('Last updated')
                            text: geoposition.position.timestamp ? geoposition.position.timestamp : '—'
                        }

                        PositionSource {
                            id: geoposition
                            active: true
                            updateInterval: 1000
                        }

                    }
                }
            }

            Tab {
                title: i18n.tr('Gyroscope')
                page: Page {
                    id: gyroscopePage
                    NoData {
                        visible: !gyroscope.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: !!gyroscope.connectedToBackend
                        Gyroscope {
                            id: gyroscope
                            active: true
                        }
                        RowField {
                            title: i18n.tr('x (º/s)')
                            text: gyroscope.reading != null ? gyroscope.reading.x : '-'
                        }
                        RowField {
                            title: i18n.tr('y (º/s)')
                            text: gyroscope.reading != null ? gyroscope.reading.y : '-'
                        }
                        RowField {
                            title: i18n.tr('z (º/s)')
                            text: gyroscope.reading != null ? gyroscope.reading.z : '-'
                        }
                    }
                }
            }

            Tab {
                title: i18n.tr('Pressure')
                page: Page {
                    id: pressurePage
                    NoData {
                        visible: !pressure.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: !!pressure.connectedToBackend
                        PressureSensor {
                            id: pressure
                            active: true
                        }
                        RowField {
                            title: i18n.tr('pressure (Pa)')
                            text: pressure.reading != null ? pressure.reading.pressure : '-'
                        }
                    }
                }
            }
        }
    }
}

