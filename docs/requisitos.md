# Requisitos y decisiones pendientes

La siguiente matriz conserva los identificadores de la ERS. La etapa sugerida y la evidencia son propuestas nuevas. La demo permite ensayar parte de los flujos con datos locales; la matriz no representa requisitos de producción implementados o validados.

| Fuente | Capacidad | Etapa sugerida | Evidencia de aceptación propuesta |
| --- | --- | --- | --- |
| REQ-01 | Acceso | Primer flujo | Usuario activo accede; usuario inactivo no; bloqueo temporal comprobado. |
| REQ-02 | Miembros | Primer flujo | Presidente administra socios; otro rol recibe denegación del servidor. |
| REQ-03 | Calendario | Primer flujo | Lista/calendario y detalle consistentes en móvil y web. |
| REQ-04 | Propuestas | Primer flujo | Se crea una propuesta con seguimiento y estado consultable. |
| REQ-05 | Confirmación | Primer flujo | Cupos incluyen acompañantes; peticiones simultáneas no exceden aforo. |
| REQ-06 | Gastos | MVP completo | Gasto válido actualiza saldo una vez y conserva comprobante. |
| REQ-07 | Aportes | MVP completo | Rechazado no suma al fondo; reintento no duplica un aporte validado. |
| REQ-08 | Registro de evento | Primer flujo | Solo el actor autorizado registra un evento completo con código único. |
| REQ-9 | Difusión | MVP completo | Se registra notificación interna y resultado; canal externo simulado. |
| REQ-10 | Proveedores | Ampliación | Registro sin duplicados según criterio acordado. |
| REQ-11 | Definición | Primer flujo básico; cotizaciones en ampliación | Aprobación o rechazo trazable y presupuesto explícito. |
| REQ-12 | Ejecución | MVP completo | Asistencia manual sin duplicados y cierre por transición válida. |
| REQ-13 | Reportes | MVP completo, PDF inicial | Resultado coincide con movimientos y asistentes autorizados. Excel posterior. |

## Estados propuestos

Separar propuesta de evento: la propuesta puede estar pendiente, aprobada o rechazada. Aprobar puede crear un evento definido. Para el evento se propone definido, registrado, difundido, en ejecución, cerrado y liquidado, con cancelación controlada. La fuente no define por completo cancelaciones, reaperturas ni liquidación; documentarlas antes de automatizarlas.

## Decisiones que deben resolverse

1. Elegir mínimos únicos de Android y hardware, distinguiendo instalación, descarga y espacio libre.
2. Acordar permisos de difusión, lectura de reportes y sucesión de la presidencia. Resolver el conflicto entre sucesor y cargo único.
3. Definir fechas de apertura/cierre de confirmación, zona horaria y comportamiento al reprogramar un evento.
4. Definir si una confirmación se modifica o cancela, cómo libera cupos y cómo trata una respuesta negativa.
5. Separar aportes mensuales al club de pagos asociados a eventos. Definir pagos parciales, sobrepagos, anulaciones y períodos.
6. Resolver cuándo se registran gastos y cómo funciona el cierre y la liquidación. Definir si exceder presupuesto bloquea o permite una excepción autorizada.
7. Sustituir contraseñas predecibles y cifrado reversible por invitaciones y hashing.
8. Definir alcance de las notificaciones internas y posponer la integración externa real hasta probar el flujo.

## Requisitos de calidad

Conservar el enfoque de accesibilidad de NF-02: texto legible, contraste, controles grandes y tareas sencillas. Traducir puntos/dp a criterios por destino, comprobar escalado de texto, lector de pantalla y teclado. El objetivo documental de 90% de tareas en menos de dos minutos requiere definir muestra, tareas y condiciones; no está demostrado.

NF-03 necesita separar caché, respuesta de API y primera carga web. Medir con 128 kbps y latencia alta. NF-06 también requiere definir acciones medidas, tamaño de datos y entorno. Registrar resultados reales, sin convertir objetivos en afirmaciones de cumplimiento.

## Pruebas prioritarias al existir código

- Autorización por rol y revocación de acceso.
- Dos confirmaciones concurrentes sobre el último cupo.
- Reintentos de aporte/gasto y consistencia del saldo.
- Transiciones inválidas, cierre repetido y cálculo con cero confirmados.
- Consulta cacheada sin red y mensajes que distingan datos antiguos de datos confirmados.
- Flujo principal web/Android/Windows con exportación y navegación accesible.

La primera demo añade pruebas de reglas locales y navegación descritas en [su alcance](demo-etapa-1.md). Los escenarios de servidor y concurrencia siguen siendo criterios para la futura implementación.
