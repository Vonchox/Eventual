# Primera demo de EVENTUAL

La demo web está publicada y verificada en [GitHub Pages](https://vonchox.github.io/Eventual/). Los flujos de compilación se guardan en el repositorio y sus ejecuciones aparecen en [GitHub Actions](https://github.com/Vonchox/Eventual/actions).

## Alcance entregado

Cliente Flutter para explorar la experiencia antes de construir el backend. Verde bosque, fondos cálidos y acentos lima. El escudo proporcionado se conserva sin recolorearlo y se incorpora como asset local. Las ilustraciones de eventos son gráficos propios dibujados en código: no dependen de imágenes remotas.

- Inicio con evento destacado, fechas y contadores derivados de los datos.
- Eventos en tarjetas o calendario mensual, con búsqueda y filtros.
- Detalle y confirmación con hasta cinco acompañantes; modificación y cancelación.
- Propuestas con validación de formulario y fecha futura.
- Selector de perfil simulado; el presidente puede aprobar una propuesta y verla convertida en un evento de ejemplo.
- Persistencia local de confirmaciones y propuestas; reinicio explícito de ejemplos.
- Menú móvil y disposición adaptable a escritorio.

Los nombres, lugares, cantidades y actividades son ficticios. Las fechas iniciales se calculan a futuro al crear o reiniciar los datos. El perfil de demostración se llama Antonio; no representa una cuenta real.

## Límites

No hay API ni base de datos compartida. Los cupos se validan frente a los datos de un solo dispositivo: no hay concurrencia real entre usuarios. El selector de rol es una herramienta de demostración y no una barrera de seguridad.

Aprobar una propuesta crea directamente un evento con 60 cupos y lugar pendiente. Es un atajo del prototipo; la versión de producción debe separar aprobación, definición y publicación. El formulario usa un mínimo propuesto de 30 caracteres para la justificación; la normalización de requisitos originales sigue pendiente.

No se implementan aún pagos, gastos, reportes, QR, WhatsApp, autenticación, permisos de servidor, datos de acompañantes ni política definitiva de cierre de inscripciones. Guardar información en preferencias locales no implica disponibilidad offline de la aplicación web: la primera carga sigue necesitando acceso a los recursos compilados. Los datos no se sincronizan entre dispositivos ni entre el origen local y el desplegado.

Esta demo no certifica todavía cumplimiento completo de los requisitos de accesibilidad o rendimiento. La siguiente etapa deberá medir tamaños de texto, lector de pantalla, teclado, conectividad y dispositivos reales.

## Verificación

Cinco pruebas aprobadas: límites de aforo/acompañantes, actualización y cancelación sin duplicados, aprobación única y serialización; flujo de confirmación en escritorio y apertura/validación del formulario en teléfono. Análisis estático sin problemas y compilación web de producción completada. En navegador se comprobó una confirmación con acompañante, su persistencia tras recarga y la adaptación móvil. La guía del cliente registra los comandos de comprobación.

GitHub Actions compiló el APK de prueba de Android y el paquete portátil de Windows x64. Ambos provienen del mismo cliente Flutter y están disponibles en los [artefactos de compilación](https://github.com/Vonchox/Eventual/actions/runs/42551284786). La validación de funcionamiento en dispositivos nativos queda pendiente.
