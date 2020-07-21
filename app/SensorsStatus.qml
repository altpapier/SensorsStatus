import QtQuick 2.2
import Ubuntu.Components 1.3
import QtPositioning 5.2
import QtSensors 5.2

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "sensorsstatus.chrisclime"
    automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    function printablePositionMethod(method) {
        var out = i18n.tr("Unknown position method");
        if (method === PositionSource.SatellitePositioningMethod) out = i18n.tr("Satellite");
        else if (method === PositionSource.NoPositioningMethod) out = i18n.tr("Not available");
        else if (method === PositionSource.NonSatellitePositioningMethod) out = i18n.tr("Non-satellite");
        else if (method === PositionSource.AllPositioningMethods) out = i18n.tr("All/Multiple");
        return out;
    }

    function printableSourceError(method) {
        var out = i18n.tr("Unknown source error");
        if (method === PositionSource.AccessError) out = i18n.tr("Access error");
        else if (method === PositionSource.ClosedError) out = i18n.tr("Closed error");
        else if (method === PositionSource.NoError) out = i18n.tr("No error");
        else if (method === PositionSource.UnknownSourceError) out = i18n.tr("Unidentified source error");
        else if (method === PositionSource.SocketError) out = i18n.tr("Socket error");
        return out;
    }

    function printableOrientation(orientation) {
        var out = i18n.tr("Unknown orientation");
        if (orientation === OrientationReading.TopUp) out = i18n.tr("Top edge is up");
        else if (orientation === OrientationReading.TopDown) out = i18n.tr("Top edge is down");
        else if (orientation === OrientationReading.LeftUp) out = i18n.tr("Left edge is up");
        else if (orientation === OrientationReading.RightUp) out = i18n.tr("Right edge is up");
        else if (orientation === OrientationReading.FaceUp) out = i18n.tr("Face is up");
        else if (orientation === OrientationReading.FaceDown) out = i18n.tr("Face is down");
        return out;
    }

    function round(number, digits) {
        return Math.round(number*Math.pow(10, digits))/Math.pow(10, digits);
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
                        visible: accelerometer.connectedToBackend
                        Accelerometer {
                            id: accelerometer
                            active: true
                        }
                        RowField {
                            title: i18n.tr('x (m/s/s)')
                            text: accelerometer.reading != null ? round(accelerometer.reading.x,1) : '-'
                        }
                        RowField {
                            title: i18n.tr('y (m/s/s)')
                            text: accelerometer.reading != null ? round(accelerometer.reading.y,1) : '-'
                        }
                        RowField {
                            title: i18n.tr('z (m/s/s)')
                            text: accelerometer.reading != null ? round(accelerometer.reading.z,1) : '-'
                        }
                    }
                }
            }

            Tab {
                title: i18n.tr('Magnetometer')
                page: Page {
                    id: magnetometerPage

                    NoData {
                        visible: !magnetometer.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: magnetometer.connectedToBackend
                        Accelerometer {
                            id: magnetometer
                            active: true
                        }
                        RowField {
                            title: i18n.tr('x')
                            text: magnetometer.reading != null ? round(magnetometer.reading.x,1) : '-'
                        }
                        RowField {
                            title: i18n.tr('y')
                            text: magnetometer.reading != null ? round(magnetometer.reading.y,1) : '-'
                        }
                        RowField {
                            title: i18n.tr('z')
                            text: magnetometer.reading != null ? round(magnetometer.reading.z,1) : '-'
                        }
                        RowField {
                            title: i18n.tr('Calibration level')
                            text: magnetometer.reading != null && magnetometer.reading.calibrationLevel != null ? magnetometer.reading.calibrationLevel : '—'
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
                        visible: altimeter.connectedToBackend

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
                        visible: compass.connectedToBackend

                        Compass {
                            id: compass
                            active: true
                        }
                        RowField {
                            title: i18n.tr('azimuth (º)')
                            text: compass.reading != null ? compass.reading.azimuth : '—'
                        }
                        RowField {
                            title: i18n.tr('Calibration level')
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
                            preferredPositioningMethods: PositionSource.SatellitePositioningMethods
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
                        visible: gyroscope.connectedToBackend
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
                        visible: pressure.connectedToBackend
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
            Tab {
                title: i18n.tr('Rotation')
                page: Page {
                    id: rotationPage
                    NoData {
                        visible: !rotation.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: rotation.connectedToBackend
                        RotationSensor {
                            id: rotation
                            active: true
                        }
                        RowField {
                            title: i18n.tr('x [°]')
                            text: rotation.reading != null ? round(rotation.reading.x, 1) : '-'
                        }
                        RowField {
                            title: i18n.tr('y [°]')
                            text: rotation.reading != null ? round(rotation.reading.y, 1) : '-'
                        }
                        RowField {
                            title: i18n.tr('z [°]')
                            visible: rotation.hasZ
                            text: rotation.reading != null ? round(rotation.reading.z, 1) : '-'
                        }
                    }
                }
            }
            Tab {
                title: i18n.tr('Orientation')
                page: Page {
                    id: orientationPage
                    NoData {
                        visible: !orientation.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: orientation.connectedToBackend
                        OrientationSensor {
                            id: orientation
                            active: true
                        }
                        RowField {
                            title: i18n.tr('Orientation')
                            text: orientation.reading != null ? printableOrientation(orientation.reading.orientation) : '-'
                        }
                    }
                }
            }
            Tab {
                title: i18n.tr('Ambient Light')
                page: Page {
                    id: ambientLightPage
                    NoData {
                        visible: !ambientLight.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: ambientLight.connectedToBackend
                        AmbientLightSensor {
                            id: ambientLight
                            active: true
                        }
                        RowField {
                            title: i18n.tr('Ambient Light')
                            text: ambientLight.reading != null ? ambientLight.reading.lightLevel : '-'
                        }
                    }
                }
            }
            Tab {
                title: i18n.tr('Light')
                page: Page {
                    id: lightPage
                    NoData {
                        visible: !light.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: light.connectedToBackend
                        LightSensor {
                            id: light
                            active: true
                        }
                        RowField {
                            title: i18n.tr('Light')
                            text: light.reading != null ? light.reading.illuminance : '-'
                        }
                    }
                }
            }
            Tab {
                title: i18n.tr('Proximity')
                page: Page {
                    id: proximityPage
                    NoData {
                        visible: !proximity.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: proximity.connectedToBackend
                        ProximitySensor {
                            id: proximity
                            active: true
                        }
                        RowField {
                            title: i18n.tr('Proximity near:')
                            text: proximity.reading != null ? proximity.reading.near : '-'
                        }
                    }
                }
            }
            Tab {
                title: i18n.tr('Temperature')
                page: Page {
                    id: temperaturePage
                    NoData {
                        visible: !temperature.connectedToBackend
                    }
                    Column {
                        spacing: units.gu(1)
                        anchors {
                            margins: units.gu(2)
                            fill: parent
                        }
                        visible: temperature.connectedToBackend
                        AmbientTemperatureSensor {
                            id: temperature
                            active: true
                        }
                        RowField {
                            title: i18n.tr('Temperature')
                            text: temperature.reading != null ? temperature.reading.temperature : '-'
                        }
                    }
                }
            }
        }
    }
}

