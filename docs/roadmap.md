# Plan de entregas

Se ha añadido una primera demo del cliente Flutter. Permite explorar el diseño y ensayar eventos, confirmaciones y propuestas con datos locales. Los hitos completos que requieren API, permisos reales y validación por dispositivo siguen pendientes. Ver [alcance de la demo](demo-etapa-1.md).

## Hito 0: consolidar el producto

Resolver decisiones de [requisitos](requisitos.md), elegir dispositivos de prueba y diseñar cuatro vistas: acceso, eventos, detalle/confirmación y administración. Crear una decisión de arquitectura con el stack y sus límites. Preparar versiones públicas de las referencias conservando créditos.

Salida: alcance aceptado del primer flujo, matriz de permisos y prototipo navegable.

## Hito 1: flujo completo mínimo

Preparar cliente Flutter y API modular, base de datos con migraciones y datos ficticios. Implementar acceso, miembros, propuesta, aprobación/registro, consulta y confirmación. Probar web y Android desde esta etapa.

Salida: un evento recorre el flujo desde propuesta hasta confirmación, con autorización en servidor y aforo protegido frente a concurrencia.

## Hito 2: MVP demostrable

Añadir aportes, gastos, comprobantes privados, saldo, asistencia manual, cierre y reporte PDF básico. Incorporar auditoría y notificación interna. Los movimientos económicos representan registros internos, sin ejecutar transferencias bancarias.

Salida: demo que explica de dónde sale cada total y quién realizó las operaciones. Completar pruebas de dinero, permisos, estados y reintentos.

## Hito 3: tercera plataforma y calidad

Adaptar Windows y generar instalador. Añadir consulta cacheada y medir baja conectividad. Validar accesibilidad con tareas y dispositivos reales, incluyendo navegación por teclado y escalado de texto. Probar empaquetado y exportaciones en cada destino.

Salida: misma operación demostrada en navegador, Android y Windows, con limitaciones documentadas.

## Hito 4: publicación para portafolio

Desplegar web/API con datos de demostración y accesos de prueba limitados. Añadir al README capturas reales, enlace de demo y un video de dos o tres minutos. Publicar APK/instalador probados, guía de instalación, resultados de pruebas y decisiones técnicas.

Identificar aportes personales respecto del trabajo académico colectivo. Describir qué existe y qué queda pendiente. Seleccionar la licencia con los titulares del material correspondiente.

Salida: otra persona puede abrir la demo o ejecutar el proyecto y verificar el flujo descrito.

## Ampliaciones posteriores

Proveedores y cotizaciones completos, QR, exportación Excel, WhatsApp real, iOS, otros escritorios y sincronización de escrituras offline. Evaluar cada ampliación como una entrega separada. Una función de IA solo tendrá prioridad cuando aporte un resultado útil y evaluable al proceso.

## Guion de demostración

1. Socio propone un evento y consulta su seguimiento.
2. Presidente lo aprueba y publica con aforo y presupuesto.
3. Otro socio confirma con acompañante; se ve el cupo restante.
4. Tesorero registra un aporte y un gasto; se explica el saldo.
5. Presidente registra asistencia y cierra; se descarga el reporte.
6. Se abre el evento descargado sin red y se muestra la fecha de actualización.

La calidad de este recorrido y su evidencia harán que el proyecto destaque. El número de plataformas será una fortaleza cuando todas puedan demostrarlo de forma consistente.
