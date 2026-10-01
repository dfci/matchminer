// Post-render: rewrite root-absolute href/src values ("/faq.html") in the
// built HTML to page-relative ones ("../faq.html"). Raw HTML such as
// _includes/footer.html skips Quarto's link resolution, and root-absolute
// links break when the site is served from a subpath (dfci.github.io/matchminer/).
// Runs with the Deno bundled in Quarto.

const outDir = Deno.env.get("QUARTO_PROJECT_OUTPUT_DIR") ?? "_site";

async function* htmlFiles(dir: string): AsyncGenerator<string> {
  for await (const entry of Deno.readDir(dir)) {
    const path = `${dir}/${entry.name}`;
    if (entry.isDirectory) yield* htmlFiles(path);
    else if (entry.name.endsWith(".html")) yield path;
  }
}

for await (const file of htmlFiles(outDir)) {
  const depth = file.slice(outDir.length + 1).split("/").length - 1;
  const prefix = depth === 0 ? "./" : "../".repeat(depth);
  const html = await Deno.readTextFile(file);
  // Only single-slash paths; protocol-relative "//host" URLs are left alone.
  const out = html.replace(/\b(href|src)="\/(?!\/)/g, `$1="${prefix}`);
  if (out !== html) await Deno.writeTextFile(file, out);
}
