import NodeCache from "node-cache";

const cache = new NodeCache({
  stdTTL: 60, // TTL por defecto: 60 segundos
  checkperiod: 120,
  useClones: false,
});

export default cache;
