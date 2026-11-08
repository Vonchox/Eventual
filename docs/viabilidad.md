# Viabilidad de EVENTUAL

## Dictamen

Es técnicamente viable construir EVENTUAL para web, móvil y escritorio. Es una aplicación de gestión con reglas de negocio, almacenamiento relacional y acceso por roles. No exige capacidades exclusivas de un sistema operativo. Su alcance completo es considerable para una persona; conviene entregar primero un flujo integral pequeño y ampliar por hitos.

La recomendación es conservar Flutter/Dart, Node.js/Express y MySQL, tecnologías ya descritas en la ERS, añadiendo TypeScript al backend. Esta es una propuesta de continuidad, no una decisión tecnológica aprobada ni una implementación existente.

## Evaluación por plataforma

| Plataforma | Viabilidad estimada | Trabajo específico |
| --- | --- | --- |
| Web | Alta para la aplicación de gestión. | Navegación por URL, teclado, accesibilidad, descarga de reportes, almacenamiento local y medición de carga inicial. |
| Android | Alta y alineada con el origen del proyecto. | Cámara/QR, permisos, almacenamiento seguro, notificaciones, dispositivos modestos y desconexiones. |
| Windows | Alta para administración. | Ventanas redimensionables, tablas, teclado, impresión/exportación, instalador y pruebas de complementos. |
| iOS | Viable con trabajo y herramientas adicionales. | Entorno Apple/Xcode, firma, dispositivos y distribución. No se compila ni valida de extremo a extremo solamente con el Windows actual. |
| macOS/Linux | Viables como ampliación. | Compilación y pruebas en los sistemas correspondientes, distribución y complementos. |

Flutter ofrece soporte para esos destinos. Su documentación distingue aplicaciones interactivas de páginas editoriales; para una futura página pública de presentación conviene HTML, separada del cliente de gestión. Fuentes: [plataformas](https://docs.flutter.dev/reference/supported-platforms), [web](https://docs.flutter.dev/platform-integration/web/faq), [iOS](https://docs.flutter.dev/platform-integration/ios/setup).

Una PWA instalada y un programa de escritorio con instalador son entregables distintos. Si el objetivo es demostrar escritorio, publicar un ejecutable Windows probado, además de la versión web.

## Por qué puede destacar en un portafolio

El valor está en demostrar un proceso real con estados, permisos, concurrencia y trazabilidad. La accesibilidad para adultos mayores y la consulta con mala conexión ofrecen problemas concretos de diseño y validación. La gestión económica permite demostrar transacciones, precisión decimal y auditoría.

La presentación debe enseñar evidencias: demo con datos ficticios, video breve, capturas propias por plataforma, instrucciones reproducibles, decisiones de arquitectura y pruebas de las reglas importantes. La documentación académica sirve como origen; hay que enlazarla con requisitos verificables y entregas reales.

## Hallazgos que afectan la implementación

| Hallazgo en las fuentes | Efecto | Resolución propuesta, pendiente de validación |
| --- | --- | --- |
| NF-01 pide Android 8, mientras NF-07 menciona Android 9. | No hay mínimo único. | Seleccionar una base única y comprobar SDK y complementos contra ella. |
| Casos de uso: 2 GB, 1.5 GHz y app de hasta 150 MB; ERS: 3 GB, 1.8 GHz y 200 MB libres. | Los criterios de aceptación no coinciden; tamaño instalado y espacio libre son métricas diferentes. | Definir dispositivo de referencia y medir cada métrica por separado. |
| ERS requiere Internet; NF-03 permite consultar eventos descargados sin conexión. | Ambigüedad del modo offline. | Lectura local de calendario y detalles; operaciones económicas y confirmaciones definitivas requieren servidor en el MVP. |
| CU-006 exige evento cerrado para gastos; otros flujos permiten gastos durante el proceso y el cierre exige gastos completos. | Puede producir un ciclo imposible de completar. | Permitir gastos en estados operativos definidos, bloquearlos tras liquidación y distinguir cierre operativo de financiero. |
| Difusión con mínimo 15 días y confirmación hasta 15 días antes. | Difundir en el límite deja una ventana nula o muy corta. | Definir apertura y cierre de inscripción explícitos. |
| Actor de difusión: secretario en unas secciones y presidente en otras. | Permisos contradictorios. | Una matriz única de permisos antes de crear endpoints. |
| CU-001/CU-003 se reutilizan en distintas secciones. | Trazabilidad ambigua. | Conservar REQ-01 a REQ-13 como referencia y asignar identificadores únicos a subflujos. |
| Alta de socio propone contraseña derivada de cédula y AES-256. | Credencial predecible y almacenamiento reversible. | Invitación aleatoria de un solo uso, vencimiento y hash de contraseña con Argon2id. |
| Gastos y aportes se describen como descuentos/depósitos bancarios. | No distingue contabilidad interna de mover dinero real. | En MVP registrar pagos realizados fuera del sistema y actualizar un saldo interno; integración bancaria fuera de alcance. |
| Reportes disponibles para todos los roles sin delimitar datos. | Alcance de lectura financiera incierto. | Reportes personales para socio y vistas autorizadas para directiva, sujeto a validación. |
| Liquidación aparece en reportes y como etapa posterior al cierre. | Falta precisar un proceso financiero completo. | Definir cálculo, responsables, aprobación y correcciones de liquidación. |

Para contraseñas, [OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html) recomienda hashing adaptativo, en lugar de cifrado reversible.

## Baja conectividad

A 128 kbps, tres segundos permiten transferir aproximadamente 48 kB brutos, antes de latencia y sobrecarga. Una imagen de 100 kB necesita aproximadamente 6.25 segundos en condiciones ideales. Por ello, el requisito de texto en menos de tres segundos debe diferenciar respuesta de datos, contenido ya cacheado y primera descarga del cliente.

La primera carga web de Flutter debe medirse temprano. Si el acceso inicial a 128 kbps en menos de tres segundos fuera obligatorio para toda la aplicación, habría que reevaluar un cliente web ligero en HTML/TypeScript. Esa alternativa reduce la reutilización de interfaz y aumenta el mantenimiento. No prometer este rendimiento sin una medición real.

El modo offline inicial debe mostrar fecha de última sincronización y evitar presentar datos locales como confirmación definitiva de cupo o pago. La sincronización de escrituras y asistencia offline se evaluará después, con reglas de conflictos, deduplicación y revocación de sesiones.

## Revisión del presupuesto recibido

La hoja contiene elicitación, análisis, especificación y validación de requisitos. Sus 143 horas corresponden a esa preparación, no a desarrollar, probar y operar web, Android y Windows.

| Concepto | Evidencia exacta en Hoja1 |
| --- | --- |
| Horas resumidas | H137:H140 = 18.5, 58.5, 46.5, 19.5; H141 = 143. |
| Total resumido | I137:I140 = 273, 760, 556.5, 238.4; I141 = 1827.90. |
| Costos directos de detalle | J9 = 273; K46 = 760.50; K85 = 556.50; J114 = 238.50. Suma verificada: 1828.50. |
| Diferencia del resumen | Fase 2: 0.50; fase 4: 0.10. Diferencia total: 0.60. |
| Resúmenes con indirectos | K26 = 341.46; E64 = 839.62; E101 = 603.81; E130 = 269.65. Suma de valores guardados: 2054.54. |

Los resúmenes copian importes manualmente: E60 = 760 frente a K46 = 760.50. El total con indirectos tampoco constituye todavía una reconciliación corregida. No se modificó el archivo ni se recalculó con Excel; se comprobaron los productos directos desde sus horas y tarifas. Hace falta un presupuesto nuevo para construcción, QA, infraestructura, almacenamiento, distribución y servicios de mensajería.

## Esfuerzo orientativo

Estimación de ingeniería propia, no derivada del Excel. Supone una persona con experiencia intermedia, un solo club, cliente compartido, API modular y servicios externos simulados al principio.

| Entrega | Horas adicionales aproximadas |
| --- | --- |
| Consolidar requisitos y prototipo | 25-45 |
| Primer flujo funcional web/Android y API | 140-220 |
| Finanzas, asistencia y reportes del MVP | 100-160 |
| Adaptación Windows, empaquetado y pruebas | 35-65 |
| Accesibilidad, fallos de red, documentación y demo | 60-110 |
| Total orientativo | 360-600 |

A 20 horas por semana son aproximadamente 18-30 semanas. Aprender Flutter/backend desde cero, integrar WhatsApp real, sincronizar escrituras offline o añadir iOS puede ampliar este rango. La confianza de la estimación es baja hasta terminar el primer flujo y medir la velocidad real.
