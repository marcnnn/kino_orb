import { Orb } from "@memgraph/orb";

export function init(ctx, content) {
  function render() {
    const container = ctx.root;

    const nodes = content.nodes;
    const edges = content.edges;

    // First `Orb` is just a namespace of the JS package
    const orb = new Orb(container);

    // Initialize nodes and edges
    orb.data.setup({ nodes, edges });

    // Render and recenter the view
    orb.view.render(() => {
      orb.view.recenter();
    });

    ctx.handleEvent("push", (dataset) => {
      console.log("Received new dataset", dataset);
      const nodes = dataset.nodes;
      const edges = dataset.edges;
      orb.data.merge({
        nodes: nodes,
        edges: edges
      });
      orb.view.render(() => {
        orb.view.recenter();
      });
    });
  }

  // If the JS view is not visible, defer initialization until it becomes visible
  if (window.innerWidth === 0) {
    window.addEventListener("resize", () => render(), { once: true });
  } else {
    render();
  }
}
