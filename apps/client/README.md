# EVENTUAL · Primera demo

Cliente Flutter con identidad verde bosque, escudo del club, calendario, eventos, confirmaciones y propuestas. Las ilustraciones están dibujadas en código y el escudo es el archivo proporcionado por el usuario, conservado sin cambios.

## Ejecutar

Entorno utilizado: Flutter 3.47.6, Dart 3.13.5.

```powershell
flutter pub get
flutter run -d chrome
```

Los proyectos Android y Windows están generados. Para ejecutarlos se necesitan sus SDK y herramientas de compilación. En Windows, los complementos requieren soporte de enlaces simbólicos (modo de desarrollador); no se modificó la configuración del equipo. No se ha validado todavía una instalación nativa.

## Comprobar y compilar

```powershell
flutter analyze --no-pub
flutter test --no-pub
flutter build web --release --no-pub --no-wasm-dry-run
node scripts/prepare-web.mjs
```

El último comando copia la compilación a `dist/`, directorio declarado para hosting. La configuración del cargador usa CanvasKit incluido en la compilación, sin descargarlo desde un CDN externo.

## Recorrido

1. Abrir **Descubrir el evento**, elegir acompañantes y confirmar.
2. Consultar **Mis confirmaciones**, modificar el grupo o cancelar.
3. Buscar eventos y alternar tarjetas/calendario en **Eventos**.
4. Enviar una idea desde **Propuestas**.
5. Seleccionar **Presidente** arriba y aprobar la propuesta. Aparece un evento de ejemplo en **Eventos**.
6. Recargar: las confirmaciones y propuestas permanecen en este navegador/dispositivo. **Reiniciar** devuelve los ejemplos iniciales.

Los perfiles son simulados. No hay autenticación, servidor, datos compartidos, transferencias, mensajería ni reportes. No ingresar información real: es un prototipo para explorar el flujo. Más detalle en [alcance de la etapa](../../docs/demo-etapa-1.md).

## Estructura

- `lib/main.dart`: interfaz y acciones de demostración.
- `lib/models.dart`: datos, confirmaciones y propuestas serializables.
- `lib/visuals.dart`: ilustraciones y fondos.
- `test/`: pruebas de reglas y navegación.
- `web/`, `android/`, `windows/`: destinos de compilación.

Las reglas del prototipo se trasladarán al servidor en la siguiente etapa. La validación local de aforo no resuelve concurrencia entre usuarios.

## Resultado de validación

Análisis sin problemas; cinco pruebas automatizadas aprobadas; compilación web de producción generada. Comprobados en navegador: inicio, confirmación con acompañante, persistencia tras recarga y adaptación a pantalla móvil. Las pruebas no certifican todavía cumplimiento completo de accesibilidad o rendimiento.
