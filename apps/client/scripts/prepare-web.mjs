import { cpSync, existsSync, mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const source = path.join(root, 'build', 'web');
if (!existsSync(path.join(source, 'index.html'))) throw new Error('Primero ejecuta flutter build web --release --no-wasm-dry-run');
mkdirSync(path.join(root, 'dist'), { recursive: true });
cpSync(source, path.join(root, 'dist'), { recursive: true });
console.log('Demo web lista en dist/.');
