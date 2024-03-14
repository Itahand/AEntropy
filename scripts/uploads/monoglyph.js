let tokenData = {};
tokenData.hash = '0xdfsafdasfs';

let pl,
  R,
  bgCl,
  WIDTH = window.innerWidth,
  HEIGHT = window.innerHeight,
  DEFAULT_SIZE = 1e3,
  DIM = Math.min(WIDTH, HEIGHT),
  M = DIM / DEFAULT_SIZE,
  glhs = [],
  i = 0,
  glhSt = {};
const blk = '#1C1C1C',
  wht = '#FAFAFA',
  gry = '#BEBAAC',
  spStn = '#EBE5DC',
  ppr = '#EFF3F2',
  prtbl = '#9C928A',
  darkgry = '#3A3433',
  gold1 = '#C0994D',
  gold2 = '#A98243',
  gold3 = '#C2B478',
  psybg = '#163648',
  rd = '#AF2A18',
  rd1 = '#6E1B0C',
  rd2 = '#922C18',
  pink = '#D446CF',
  org = '#BD7B3A',
  org2 = '#995C26',
  org3 = '#7F5329',
  psyan = '#51A694',
  ltbl = '#C7DBE3',
  ltbl2 = '#9DC6D8',
  ltbl3 = '#4D799A',
  ltbl4 = '#85A0AB',
  ylw = '#FAF759',
  alien = '#75EF70',
  bleu = '#476AD4',
  darkylw = '#EEB340',
  dkBl = '#1D3890',
  xGrn = '#4C824B',
  lMnPl = [
    { value: alien, weight: 1 },
    { value: darkylw, weight: 1 },
    { value: ltbl, weight: 0.5 },
    { value: ltbl2, weight: 0.5 },
    { value: gold1, weight: 1 },
    { value: prtbl, weight: 1 },
  ],
  dMnPl = [
    { value: dkBl, weight: 1 },
    { value: ltbl3, weight: 1 },
    { value: org2, weight: 1 },
    { value: rd, weight: 1 },
    { value: xGrn, weight: 1 },
    { value: prtbl, weight: 1 },
  ],
  lMnSPl = [
    { value: alien, weight: 1 },
    { value: darkylw, weight: 1 },
    { value: ltbl2, weight: 1 },
    { value: gold1, weight: 1 },
    { value: prtbl, weight: 1 },
    { value: pink, weight: 1 },
  ],
  dMnSPl = [
    { value: dkBl, weight: 1 },
    { value: ltbl3, weight: 1 },
    { value: org2, weight: 1 },
    { value: rd, weight: 1 },
    { value: xGrn, weight: 1 },
  ],
  prtblPl = [
    { value: ppr, weight: 1 },
    { value: prtbl, weight: 3 },
    { value: spStn, weight: 1 },
    { value: gry, weight: 1 },
    { value: darkgry, weight: 0.1 },
  ],
  yTPl = [
    { value: wht, weight: 5 },
    { value: ylw, weight: 0.1 },
  ],
  thrOk = [
    { value: rd, weight: 1 },
    { value: bleu, weight: 1 },
  ],
  thrD2Pl = [
    { value: rd, weight: 1 },
    { value: dkBl, weight: 1 },
  ],
  alienPl = [
    { value: ylw, weight: 0.5 },
    { value: alien, weight: 1 },
    { value: pink, weight: 2 },
  ],
  gMnPl = [
    { value: gold1, weight: 5 },
    { value: gold2, weight: 1 },
    { value: gold3, weight: 0.5 },
  ],
  psPl = [
    { value: org, weight: 5 },
    { value: org2, weight: 1 },
    { value: org3, weight: 0.5 },
    { value: psyan, weight: 0.1 },
  ],
  tlxPl = [
    { value: ltbl2, weight: 5 },
    { value: ltbl, weight: 1 },
    { value: ltbl4, weight: 0.5 },
    { value: ltbl3, weight: 0.1 },
  ],
  anrPl = [
    { value: rd, weight: 5 },
    { value: rd1, weight: 1 },
    { value: rd2, weight: 0.5 },
  ],
  rPl = [
    { value: rd, weight: 1 },
    { value: blk, weight: 2 },
  ],
  cPl = [
    { value: ltbl2, weight: 2 },
    { value: pink, weight: 1 },
  ],
  ltBg = [
    { value: ppr, weight: 1 },
    { value: spStn, weight: 2 },
  ];
let plOp = [
  {
    value: { cl: prtblPl, bg: [{ value: blk, weight: 1 }] },
    label: 'prtbl',
    weight: 1,
  },
  {
    value: { cl: anrPl, bg: [{ value: blk, weight: 1 }] },
    label: 'anger',
    weight: 1,
  },
  { value: { cl: rPl, bg: ltBg }, label: 'riot', weight: 1 },
  {
    value: { cl: [{ value: blk, weight: 1 }], bg: ltBg },
    label: 'plain',
    weight: 3,
  },
  {
    value: { cl: gMnPl, bg: [{ value: psybg, weight: 1 }] },
    label: 'gold mne',
    weight: 1,
  },
  {
    value: { cl: psPl, bg: [{ value: blk, weight: 1 }] },
    label: 'pysycho',
    weight: 0.2,
  },
  {
    value: { cl: tlxPl, bg: [{ value: blk, weight: 1 }] },
    label: 'teletext',
    weight: 1,
  },
  {
    value: { cl: yTPl, bg: [{ value: blk, weight: 1 }] },
    label: 'yellow tinge',
    weight: 0.2,
  },
  {
    value: { cl: cPl, bg: [{ value: blk, weight: 1 }] },
    label: 'console',
    weight: 1,
  },
  {
    value: { cl: alienPl, bg: [{ value: darkgry, weight: 1 }] },
    label: 'alien',
    weight: 1,
  },
  {
    value: { cl: thrOk, bg: [{ value: blk, weight: 1 }] },
    label: '3d',
    weight: 1,
  },
  {
    value: { cl: thrD2Pl, bg: [{ value: spStn, weight: 1 }] },
    label: '3d',
    weight: 1,
  },
  {
    value: { cl: [{ value: blk, weight: 1 }], bg: lMnPl },
    label: 'mono',
    weight: 2,
  },
  {
    value: { cl: [{ value: ppr, weight: 1 }], bg: dMnPl },
    label: 'mono',
    weight: 2,
  },
  {
    value: { cl: dMnSPl, bg: [{ value: spStn, weight: 1 }], sgl: !0 },
    label: 'mono',
    weight: 2,
  },
  {
    value: { cl: lMnSPl, bg: [{ value: blk, weight: 1 }], sgl: !0 },
    label: 'mono',
    weight: 2,
  },
  {
    value: { cl: dMnSPl, bg: [{ value: spStn, weight: 1 }] },
    label: 'extravaganza',
    weight: 0.1,
  },
  {
    value: { cl: lMnSPl, bg: [{ value: blk, weight: 1 }] },
    label: 'extravaganza',
    weight: 0.1,
  },
];
const sEdOp = [
    { value: 4, weight: 1 },
    { value: 5, weight: 2 },
    { value: 6, weight: 1 },
  ],
  mgOp = [
    { value: 10, weight: 1, label: 'none' },
    { value: 20, weight: 3, label: 'smol af' },
    { value: 40, weight: 5, label: 'smol' },
    { value: 70, weight: 5, label: 'medium' },
    { value: 100, weight: 3, label: 'large' },
    { value: 150, weight: 1, label: 'humongous' },
  ],
  dtOp = [
    { value: 5, weight: 1, label: 'low af' },
    { value: 10, weight: 2, label: 'low' },
    { value: 15, weight: 0.5, label: 'medium' },
    { value: 18, weight: 0.3, label: 'high' },
    { value: 20, weight: 0.2, label: 'high af' },
  ],
  glhSzOp = [
    { value: { mn: 8, mx: 12 }, weight: 0.3, label: 'humongous' },
    { value: { mn: 13, mx: 20 }, weight: 0.5, label: 'larger' },
    { value: { mn: 21, mx: 30 }, weight: 3, label: 'large' },
    { value: { mn: 31, mx: 50 }, weight: 1, label: 'medium' },
    { value: { mn: 51, mx: 75 }, weight: 0.5, label: 'smol' },
    { value: { mn: 76, mx: 99 }, weight: 0.2, label: 'smol af' },
  ],
  thiccOp = [
    { value: 2, weight: 0.3, label: 'tn af' },
    { value: 2.5, weight: 1, label: 'tn' },
    { value: 3, weight: 2, label: 'medium' },
    { value: 3.5, weight: 1, label: 'slight thicc' },
    { value: 4, weight: 0.5, label: 'thicc' },
    { value: 5, weight: 0.2, label: 'thicc af' },
  ],
  stkDfOp = [
    { value: 0, weight: 0.5, label: 'none' },
    { value: 0.1, weight: 1, label: 'smol' },
    { value: 0.2, weight: 10, label: 'medium' },
    { value: 0.35, weight: 3, label: 'large' },
    { value: 0.45, weight: 2, label: 'larger' },
    { value: 0.6, weight: 0.5, label: 'humongous' },
  ],
  oftOp = [
    { value: 0, weight: 1, label: 'none' },
    { value: 1, weight: 0.5, label: 'smol' },
    { value: 2, weight: 0.3, label: 'medium' },
    { value: 3, weight: 0.15, label: 'big' },
  ];
let sDrOp = [
    { value: 'blank', weight: 1 },
    { value: 'sides-dn', weight: 50 },
    { value: 'l', weight: 50 },
    { value: 'l-cc-dot', weight: 1 },
    { value: 'double-cc', weight: 1 },
    { value: 'eye', weight: 1 },
    { value: 'infinity', weight: 1 },
    { value: 'sn', weight: 1 },
    { value: 'mo', weight: 1 },
    { value: 'spiral', weight: 1 },
    { value: 'star', weight: 1 },
    { value: 'dot', weight: 1 },
    { value: 'pr', weight: 0.1 },
    { value: 'sp-pr', weight: 0.1 },
    { value: 'l-pr', weight: 0 },
    { value: 'l-sp-pr', weight: 0.1 },
    { value: 'bolt', weight: 1 },
    { value: 'hz-rt', weight: 1 },
    { value: 'vt-rt', weight: 1 },
  ],
  dwOp = [
    { value: 'blank', weight: 1 },
    { value: 'dn', weight: 10 },
    { value: 'l', weight: 10 },
    { value: 'r', weight: 10 },
    { value: 'dn-l', weight: 10 },
    { value: 'dn-r', weight: 10 },
    { value: 'dot', weight: 1 },
    { value: 'double-cc', weight: 1 },
    { value: 'eye', weight: 1 },
    { value: 'infinity', weight: 0.5 },
    { value: 'star', weight: 2 },
    { value: 'sn', weight: 0.5 },
    { value: 'mo', weight: 0.5 },
    { value: 'spiral', weight: 0.5 },
    { value: 'pr', weight: 0.1 },
    { value: 'sp-pr', weight: 0.1 },
    { value: 'l-pr', weight: 0 },
    { value: 'l-sp-pr', weight: 0.1 },
    { value: 'extra-l-pr', weight: 0.05 },
    { value: 'bolt', weight: 1 },
    { value: 'l-cc-dot', weight: 1 },
    { value: 'hz-rt', weight: 1 },
    { value: 'vt-rt', weight: 1 },
  ];
function setup() {
  createCanvas(DIM, DIM), colorMode(HSB, 100);
}
function draw() {
  (R = new Rdom()),
    (pl = chw(plOp)),
    (glhSt.stkDf = chw(stkDfOp)),
    (glhSt.mg = chw(mgOp)),
    (glhSt.oft = chw(oftOp)),
    (glhSt.sz = DEFAULT_SIZE - 2 * glhSt.mg),
    (glhSt.dt = chw(dtOp)),
    (sP = glhSt.mg * M);
  const t = chw(thiccOp),
    s = chw(glhSzOp);
  if (
    ((glhSt.gDSz = R.rnd_int(s.mn, s.mx)),
    (glhSt.stkSz = ceil(glhSt.sz / glhSt.gDSz / t)),
    glhSt.stkSz > 10 && (glhSt.mtFr = 2),
    (bgCl = chw(pl.bg)),
    background(bgCl),
    pl.sgl)
  ) {
    const t = R.rnd_chc(pl.cl);
    pl.cl = [t];
  }
  let i = sP,
    h = sP;
  (glhs[0] = new G(i, h)), glhs[0].dy(), noStroke(), fill(bgCl);
  console.log(DIM, M);
  for (let t = 0; t < 5e4; t++)
    circle(R.rnd_dec() * DIM, R.rnd_dec() * DIM, R.rnd_dec() * (M / 1.2));
  gnl(20), noLoop();
}
class G {
  constructor(t, s) {
    (this.gDW = glhSt.sz * M),
      (this.gDH = glhSt.sz * M),
      (this.gDSz = glhSt.gDSz),
      (this.gDPst = []),
      (this.tgPst = []),
      (this.epPst = []),
      (this.gDIns = []),
      (this.cl = []),
      (this.stkSz = []),
      (this.saX = t),
      (this.saY = s),
      this.stkCl,
      (this.saGp = 0);
  }
  crtGd() {
    let t = 500,
      s = 1e5,
      i = glhSt.dt;
    for (let h = 1; h <= this.gDSz; h++)
      for (let e = 1; e <= this.gDSz; e++) {
        const g = noise(t) * i * M,
          l = noise(s) * i * M,
          D = R.rnd_num(-glhSt.oft, glhSt.oft) * M,
          P = R.rnd_num(-glhSt.oft, glhSt.oft) * M;
        let n = this.saX + h * (this.gDW / (this.gDSz + 1)) + g + D,
          d = this.saY + e * (this.gDW / (this.gDSz + 1)) + l + P,
          a = createVector(n, d);
        this.gDPst.push(a), (t += 0.15), (s += 0.05);
      }
  }
  gnrCl() {
    for (let t = 0; t < this.gDPst.length; t++) this.cl[t] = chw(pl.cl);
  }
  gnrStkSz() {
    for (let t = 0; t < this.gDPst.length; t++)
      this.stkSz[t] = ceil(glhSt.sz / glhSt.gDSz / R.rnd_num(3, 6));
  }
  dy() {
    this.crtGd(), this.gnrCl(), this.gnrStkSz();
    for (let t = 0; t < this.gDPst.length; t++) {
      const s = glhSt.stkSz * R.rnd_num(1 - glhSt.stkDf, 1);
      let i;
      strokeWeight(s * M),
        (this.stkCl = chw(pl.cl)),
        stroke(this.stkCl),
        (glhSt.cnStk = s),
        (glhSt.cnCl = this.stkCl),
        this.iOFS(t)
          ? ((i = chw(sDrOp)), this.fmt(i, t))
          : ((i = chw(dwOp)), this.fmt(i, t));
    }
    for (let t = 0; t < 10; t++) this.syClGp();
    for (let t = 0; t < this.gDPst.length; t++)
      if (this.gDIns[t]) {
        const s = this.gDIns[t].clGp;
        (glhSt.cnStk = this.stkSz[s] * M),
          strokeWeight(this.stkSz[s] * M),
          stroke(this.cl[s]),
          (glhSt.cnCl = this.cl[s]),
          this.dwDt(t);
      }
  }
  dwDt(t) {
    const s = this.gtTtIx(t, this.gDIns[t].dir);
    dwLn(this.gDPst[t].x, this.gDPst[t].y, this.gDPst[s].x, this.gDPst[s].y);
  }
  dwDo(t) {
    const s = (glhSt.cnStk / 2) * 0.75 * M;
    dwCc(this.gDPst[t].x, this.gDPst[t].y, s);
  }
  dwPy(t) {
    dwLn(
      this.gDPst[t + this.gDSz].x,
      this.gDPst[t + this.gDSz].y,
      this.gDPst[t + 1].x,
      this.gDPst[t + 1].y,
    ),
      dwLn(
        this.gDPst[t + this.gDSz].x,
        this.gDPst[t + this.gDSz].y,
        this.gDPst[t + 2 * this.gDSz + 1].x,
        this.gDPst[t + 2 * this.gDSz + 1].y,
      ),
      dwLn(
        this.gDPst[t + 1].x,
        this.gDPst[t + 1].y,
        this.gDPst[t + 2 * this.gDSz + 1].x,
        this.gDPst[t + 2 * this.gDSz + 1].y,
      );
  }
  dwSpPy(t) {
    dwLn(
      this.gDPst[t + this.gDSz].x,
      this.gDPst[t + this.gDSz].y,
      this.gDPst[t + 1].x,
      this.gDPst[t + 1].y,
    ),
      dwLn(
        this.gDPst[t + this.gDSz].x,
        this.gDPst[t + this.gDSz].y,
        this.gDPst[t + 2 * this.gDSz + 1].x,
        this.gDPst[t + 2 * this.gDSz + 1].y,
      ),
      dwLn(
        this.gDPst[t + 1].x,
        this.gDPst[t + 1].y,
        this.gDPst[t + 2 * this.gDSz + 1].x,
        this.gDPst[t + 2 * this.gDSz + 1].y,
      ),
      dwLn(
        this.gDPst[t + this.gDSz].x,
        this.gDPst[t + this.gDSz].y,
        this.gDPst[t + this.gDSz + 1].x,
        this.gDPst[t + this.gDSz + 1].y,
      );
  }
  dwLPy(t) {
    dwLn(
      this.gDPst[t + 2 * this.gDSz].x,
      this.gDPst[t + 2 * this.gDSz].y,
      this.gDPst[t + 2].x,
      this.gDPst[t + 2].y,
      'cm',
      5,
    ),
      dwLn(
        this.gDPst[t + 2 * this.gDSz].x,
        this.gDPst[t + 2 * this.gDSz].y,
        this.gDPst[t + 2 + 4 * this.gDSz].x,
        this.gDPst[t + 2 + 4 * this.gDSz].y,
        'cm',
        5,
      ),
      dwLn(
        this.gDPst[t + 2].x,
        this.gDPst[t + 2].y,
        this.gDPst[t + 2 + 4 * this.gDSz].x,
        this.gDPst[t + 2 + 4 * this.gDSz].y,
        'cm',
        5,
      );
  }
  dwLSpPy(t) {
    const s = createVector(
        this.gDPst[t + 2 * this.gDSz].x,
        this.gDPst[t + 2 * this.gDSz].y,
      ),
      i = createVector(this.gDPst[t + 2].x, this.gDPst[t + 2].y),
      h = createVector(
        this.gDPst[t + 2 + 2 * this.gDSz].x,
        this.gDPst[t + 2 + 2 * this.gDSz].y,
      ),
      e = createVector(
        this.gDPst[t + 2 + 4 * this.gDSz].x,
        this.gDPst[t + 2 + 4 * this.gDSz].y,
      ),
      g = createVector(
        this.gDPst[t + 1 + 1 * this.gDSz].x,
        this.gDPst[t + 1 + 1 * this.gDSz].y,
      ),
      l = createVector(
        this.gDPst[t + 1 + 3 * this.gDSz].x,
        this.gDPst[t + 1 + 3 * this.gDSz].y,
      ),
      D = R.rnd_chc(['mL-to-rB', 'mR-to-lB', 'pa', 'sp', 'sp-op', 'trg']);
    switch (
      (dwLn(
        this.gDPst[t + 2 * this.gDSz].x,
        this.gDPst[t + 2 * this.gDSz].y,
        this.gDPst[t + 2].x,
        this.gDPst[t + 2].y,
      ),
      dwLn(
        this.gDPst[t + 2 * this.gDSz].x,
        this.gDPst[t + 2 * this.gDSz].y,
        this.gDPst[t + 2 + 4 * this.gDSz].x,
        this.gDPst[t + 2 + 4 * this.gDSz].y,
      ),
      dwLn(
        this.gDPst[t + 2].x,
        this.gDPst[t + 2].y,
        this.gDPst[t + 2 + 4 * this.gDSz].x,
        this.gDPst[t + 2 + 4 * this.gDSz].y,
      ),
      D)
    ) {
      case 'mL-to-rB':
        dwLn(g.x, g.y, e.x, e.y);
        break;
      case 'mR-to-lB':
        dwLn(l.x, l.y, i.x, i.y);
        break;
      case 'pa':
        dwLn(l.x, l.y, g.x, g.y);
        break;
      case 'sp':
        dwLn(s.x, s.y, h.x, h.y);
        break;
      case 'sp-op':
        dwLn(s.x, s.y, h.x, h.y),
          dwLn(g.x, g.y, h.x, h.y),
          dwLn(l.x, l.y, h.x, h.y);
        break;
      case 'trg':
        dwLn(l.x, l.y, g.x, g.y),
          dwLn(g.x, g.y, h.x, h.y),
          dwLn(l.x, l.y, h.x, h.y);
    }
  }
  dwXLPy(t) {
    dwLn(
      this.gDPst[t + 3 * this.gDSz].x,
      this.gDPst[t + 3 * this.gDSz].y,
      this.gDPst[t + 3].x,
      this.gDPst[t + 3].y,
      'cm',
      6,
    ),
      dwLn(
        this.gDPst[t + 3 * this.gDSz].x,
        this.gDPst[t + 3 * this.gDSz].y,
        this.gDPst[t + 3 + 6 * this.gDSz].x,
        this.gDPst[t + 3 + 6 * this.gDSz].y,
        'cm',
        6,
      ),
      dwLn(
        this.gDPst[t + 3].x,
        this.gDPst[t + 3].y,
        this.gDPst[t + 3 + 6 * this.gDSz].x,
        this.gDPst[t + 3 + 6 * this.gDSz].y,
        'cm',
        6,
      );
  }
  dwBl(t) {
    dwLn(
      this.gDPst[t + this.gDSz].x,
      this.gDPst[t + this.gDSz].y,
      this.gDPst[t + 1].x,
      this.gDPst[t + 1].y,
    ),
      dwLn(
        this.gDPst[t + 1].x,
        this.gDPst[t + 1].y,
        this.gDPst[t + 1 + this.gDSz].x,
        this.gDPst[t + 1 + this.gDSz].y,
      ),
      dwLn(
        this.gDPst[t + 1 + this.gDSz].x,
        this.gDPst[t + 1 + this.gDSz].y,
        this.gDPst[t + 2].x,
        this.gDPst[t + 2].y,
      );
  }
  dwLCcDo(t) {
    let s = this.gDPst[t].dist(this.gDPst[t + 1]),
      i = createVector(s / 2, s / 2),
      h = p5.Vector.add(this.gDPst[t], i);
    strokeWeight(glhSt.cnStk * M), dwCc(h.x, h.y, s / 1.5);
  }
  dwDuCc(t) {
    let s = this.gDPst[t].dist(this.gDPst[t + 1]),
      i = createVector(s / 2, s / 2),
      h = p5.Vector.add(this.gDPst[t], i);
    strokeWeight(glhSt.cnStk * M),
      color(0).setAlpha(0),
      dwCc(h.x, h.y, s / 1.3),
      dwCc(h.x, h.y, s / 10);
  }
  dwHzRg(t) {
    const s = createVector(this.gDPst[t].x, this.gDPst[t].y),
      i = createVector(
        this.gDPst[t + 2 * this.gDSz].x,
        this.gDPst[t + 2 * this.gDSz].y,
      ),
      h = createVector(
        this.gDPst[t + this.gDSz].x,
        this.gDPst[t + this.gDSz].y,
      ),
      e = createVector(
        this.gDPst[t + 1 + this.gDSz].x,
        this.gDPst[t + 1 + this.gDSz].y,
      ),
      g = createVector(this.gDPst[t + 1].x, this.gDPst[t + 1].y),
      l = createVector(
        this.gDPst[t + 1 + 2 * this.gDSz].x,
        this.gDPst[t + 1 + 2 * this.gDSz].y,
      ),
      D = p5.Vector.lerp(h, e, 0.5);
    dwLn(
      this.gDPst[t].x,
      this.gDPst[t].y,
      this.gDPst[t + 2 * this.gDSz].x,
      this.gDPst[t + 2 * this.gDSz].y,
      'cm',
      5,
    ),
      dwLn(
        this.gDPst[t].x,
        this.gDPst[t].y,
        this.gDPst[t + 1].x,
        this.gDPst[t + 1].y,
      ),
      dwLn(
        this.gDPst[t + 1].x,
        this.gDPst[t + 1].y,
        this.gDPst[t + 2 * this.gDSz + 1].x,
        this.gDPst[t + 2 * this.gDSz + 1].y,
        'cm',
        5,
      ),
      dwLn(
        this.gDPst[t + 2 * this.gDSz].x,
        this.gDPst[t + 2 * this.gDSz].y,
        this.gDPst[t + 2 * this.gDSz + 1].x,
        this.gDPst[t + 2 * this.gDSz + 1].y,
      );
    switch (R.rnd_chc(['sx-l', 'sx-r', 'sp', 'env', 'dot', 'none'])) {
      case 'sx-l':
        dwLn(s.x, s.y, l.x, l.y);
        break;
      case 'sx-r':
        dwLn(i.x, i.y, g.x, g.y);
        break;
      case 'sp':
        dwLn(h.x, h.y, e.x, e.y);
        break;
      case 'env':
        dwLn(s.x, s.y, D.x, D.y), dwLn(i.x, i.y, D.x, D.y);
        break;
      case 'dot':
        dwCc(D.x, D.y, M);
    }
  }
  dwVtRg(t) {
    const s = createVector(this.gDPst[t].x, this.gDPst[t].y),
      i = createVector(
        this.gDPst[t + this.gDSz].x,
        this.gDPst[t + this.gDSz].y,
      ),
      h = createVector(this.gDPst[t + 1].x, this.gDPst[t + 1].y),
      e = createVector(
        this.gDPst[t + 1 + this.gDSz].x,
        this.gDPst[t + 1 + this.gDSz].y,
      ),
      g = createVector(this.gDPst[t + 2].x, this.gDPst[t + 2].y),
      l = createVector(
        this.gDPst[t + 2 + this.gDSz].x,
        this.gDPst[t + 2 + this.gDSz].y,
      ),
      D = p5.Vector.lerp(h, e, 0.5);
    dwLn(
      this.gDPst[t].x,
      this.gDPst[t].y,
      this.gDPst[t + this.gDSz].x,
      this.gDPst[t + this.gDSz].y,
    ),
      dwLn(
        this.gDPst[t].x,
        this.gDPst[t].y,
        this.gDPst[t + 2].x,
        this.gDPst[t + 2].y,
        'cm',
        5,
      ),
      dwLn(
        this.gDPst[t + 2].x,
        this.gDPst[t + 2].y,
        this.gDPst[t + this.gDSz + 2].x,
        this.gDPst[t + this.gDSz + 2].y,
      ),
      dwLn(
        this.gDPst[t + this.gDSz].x,
        this.gDPst[t + this.gDSz].y,
        this.gDPst[t + this.gDSz + 2].x,
        this.gDPst[t + this.gDSz + 2].y,
        'cm',
        5,
      );
    switch (
      R.rnd_chc(['sx-l', 'sx-r', 'sp', 'l-env', 'r-env', 'dot', 'none'])
    ) {
      case 'sx-l':
        dwLn(s.x, s.y, l.x, l.y);
        break;
      case 'sx-r':
        dwLn(i.x, i.y, g.x, g.y);
        break;
      case 'sp':
        dwLn(h.x, h.y, e.x, e.y);
        break;
      case 'l-env':
        dwLn(s.x, s.y, D.x, D.y), dwLn(g.x, g.y, D.x, D.y);
        break;
      case 'r-env':
        dwLn(i.x, i.y, D.x, D.y), dwLn(l.x, l.y, D.x, D.y);
        break;
      case 'dot':
        dwCc(D.x, D.y, M);
    }
  }
  dwSn(t) {
    R.rnd_dec(), TWO_PI;
    let s = this.gDPst[t].dist(this.gDPst[t + 2]),
      i = createVector(s / 2, s / 2),
      h = p5.Vector.add(this.gDPst[t], i);
    color(0).setAlpha(0), angleMode(DEGREES);
    let e = R.rnd_num(0, 360),
      g = e + 360,
      l = 360 / R.rnd_int(7, 12);
    for (let t = e; t <= g; t += l) {
      dwLn(
        h.x + (s / 1.5) * sin(t),
        h.y + (s / 1.5) * cos(t),
        h.x + (s / 2) * sin(t),
        h.y + (s / 2) * cos(t),
      );
    }
    dwCc(h.x, h.y, s / 5);
  }
  dwMo(t) {
    createVector(this.gDPst[t].x, this.gDPst[t].y);
    const s = createVector(
        this.gDPst[t + this.gDSz].x,
        this.gDPst[t + this.gDSz].y,
      ),
      i = createVector(
        this.gDPst[t + 2 + this.gDSz].x,
        this.gDPst[t + 2 + this.gDSz].y,
      ),
      h = createVector(
        this.gDPst[t + 1 + this.gDSz].x,
        this.gDPst[t + 1 + this.gDSz].y,
      ),
      e = this.gDPst[t].dist(this.gDPst[t + 2]);
    let g;
    switch (
      R.rnd_chc([
        'waxing-crescent',
        'fs-quarter',
        'waxing-gibbous',
        'full-mo',
        'wanning-gibbous',
        'third-quarter',
        'waning-crescent',
      ])
    ) {
      case 'waxing-crescent':
        (g = R.rnd_num(2, 3)),
          scl(h.x, h.y, e / 2, (e / 2) * 0.9, (-PI / 9) * 6, (PI / 9) * 12),
          scl(
            h.x - e / g,
            h.y,
            e / 2,
            (e / 2) * 0.9,
            (-PI / 9) * 3,
            (PI / 9) * 6,
          );
        break;
      case 'fs-quarter':
        scl(h.x, h.y, e / 2, (e / 2) * 0.9, (-PI / 9) * 4, (PI / 9) * 8),
          dwLn(s.x, s.y, i.x, i.y);
        break;
      case 'waxing-gibbous':
        scl(h.x, h.y, e / 2, (e / 2) * 0.9, (-PI / 9) * 5, (PI / 9) * 10),
          scl(
            h.x + e / 8,
            h.y,
            e / 2,
            (e / 2) * 0.9,
            (PI / 9) * 6,
            (PI / 9) * 6,
          );
        break;
      case 'wanning-gibbous':
        scl(h.x, h.y, e / 2, (e / 2) * 0.9, (PI / 9) * 4, (PI / 9) * 10),
          scl(
            h.x - e / 8,
            h.y,
            e / 2,
            (e / 2) * 0.9,
            (-PI / 9) * 3,
            (PI / 9) * 6,
          );
        break;
      case 'full-mo':
        scl(h.x, h.y, e / 2, (e / 2) * 0.9, 0, TWO_PI);
        break;
      case 'third-quarter':
        scl(h.x, h.y, e / 2, (e / 2) * 0.9, (PI / 9) * 5, (PI / 9) * 8),
          dwLn(s.x, s.y, i.x, i.y);
        break;
      case 'waning-crescent':
        (g = R.rnd_num(2, 3)),
          scl(h.x, h.y, e / 2, (e / 2) * 0.9, (PI / 9) * 3, (PI / 9) * 12),
          scl(
            h.x + e / g,
            h.y,
            e / 2,
            (e / 2) * 0.9,
            (PI / 9) * 6,
            (PI / 9) * 6,
          );
    }
  }
  dwSr(t) {
    let s = this.gDPst[t].dist(this.gDPst[t + 1]),
      i = createVector(s / 2, s / 2),
      h = p5.Vector.add(this.gDPst[t], i),
      e = color(0),
      g = 360 / chw(sEdOp);
    e.setAlpha(0), angleMode(DEGREES);
    let l = R.rnd_num(0, 360);
    strokeWeight(glhSt.cnStk * M);
    let D = l + 360;
    for (let t = l; t <= D; t += g) {
      dwLn(
        h.x + (s / 1.5) * sin(t),
        h.y + (s / 1.5) * cos(t),
        h.x + (s / 6) * sin(t),
        h.y + (s / 6) * cos(t),
      );
    }
    dwCc(h.x, h.y, M);
  }
  dwSpr(t) {
    let s = this.gDPst[t].dist(this.gDPst[t + 2]),
      i = createVector(s / 2, s / 2),
      h = p5.Vector.add(this.gDPst[t], i);
    angleMode(DEGREES), strokeWeight(0.8 * glhSt.cnStk * M);
    let e = -999,
      g = -999,
      l = R.rnd_num(0, 360),
      D = R.rnd_num(680, 1140),
      P = l + D,
      n = R.rnd_int(30, 60),
      d = D / n,
      a = s / n;
    for (let t = l; t <= P; t += d) {
      const i = h.x + (s / 1.5) * sin(t),
        l = h.y + (s / 1.5) * cos(t);
      e > -999 && dwLn(e, g, i, l, 'tn'), (e = i), (g = l), (s -= a);
    }
    strokeWeight(1 * glhSt.stkSz * M);
  }
  dwMEy(t) {
    R.rnd_dec(2 * PI);
    let s = this.gDPst[t].dist(this.gDPst[t + 1]),
      i = this.gDPst[t + 1 + this.gDSz],
      h = -999,
      e = -999,
      g = color(0);
    strokeWeight(0.9 * glhSt.cnStk * M), g.setAlpha(0), angleMode(DEGREES);
    const l = R.rnd_num(1.8, 3.5);
    for (let t = 0; t <= 360; t += 10) {
      const g = i.x + sin(t) * s,
        D = i.y + (cos(t) * pow(cos(t), 2) * s) / l;
      h > -999 && sl(g, D, h, e, 0.5, 0.5 * M), (h = g), (e = D);
    }
    const D = R.rnd_num(5, 10);
    dwCc(i.x, i.y, s / D);
  }
  dwIf(t) {
    let s = this.gDPst[t].dist(this.gDPst[t + 1]),
      i = p5.Vector.lerp(this.gDPst[t], this.gDPst[t + 2 * this.gDSz + 1], 0.5),
      h = -999,
      e = -999,
      g = color(0);
    strokeWeight(0.9 * glhSt.cnStk * M), g.setAlpha(0), angleMode(DEGREES);
    const l = R.rnd_num(1, 2);
    for (let t = 0; t <= 360; t += 10) {
      const g = i.x + sin(t) * s,
        D = i.y + (cos(t) * sin(t) * s) / l;
      h > -999 && dwLn(g, D, h, e, 'tn'), (h = g), (e = D);
    }
  }
  dwEy(t) {
    let s = this.gDPst[t].dist(this.gDPst[t + 1]),
      i = p5.Vector.lerp(this.gDPst[t], this.gDPst[t + 2 * this.gDSz + 1], 0.5),
      h = -999,
      e = -999,
      g = color(0);
    strokeWeight(0.9 * glhSt.cnStk * M), g.setAlpha(0), angleMode(DEGREES);
    const l = R.rnd_num(1.8, 3.5);
    for (let t = 0; t <= 360; t += 10) {
      const g = i.x + sin(t) * s,
        D = i.y + (cos(t) * pow(cos(t), 2) * s) / l;
      h > -999 && dwLn(g, D, h, e, 'tn'), (h = g), (e = D);
    }
    const D = R.rnd_num(5, 10);
    dwCc(i.x, i.y, s / D);
  }
  gtTtIx(t, s) {
    switch (s) {
      case 'dn':
        return t + 1;
      case 'l':
        return t - this.gDSz;
      case 'r':
        return t + this.gDSz;
      case 'dnR':
        return t + (this.gDSz + 1);
      case 'dnL':
        return t - (this.gDSz - 1);
    }
  }
  aLNClGp(t, s) {
    const i = this.gDIns[t].clGp,
      h = this.gDIns[s].clGp,
      e = min([i, h]);
    (this.gDIns[t].clGp = e), (this.gDIns[s].clGp = e);
  }
  syClGp() {
    for (let t = 0; t < this.gDPst.length; t++)
      if (this.gDIns[t]) {
        this.gDIns[t].clGp;
        const s = this.gtTtIx(t, this.gDIns[t].dir);
        this.gDIns[s] && this.aLNClGp(t, s);
        for (let i = 0; i < this.gDPst.length; i++)
          if (this.gDIns[i] && t != i) {
            this.gtTtIx(i, this.gDIns[i].dir) == s && this.aLNClGp(t, i);
          }
      }
  }
  isFirstCl(t) {
    if (t < this.gDSz) return !0;
  }
  isLsCl(t) {
    if (t > this.gDSz * this.gDSz - (this.gDSz + 1)) return !0;
  }
  isLsRw(t) {
    if ((t + 1) % this.gDSz == 0) return !0;
  }
  isFirstRw(t) {
    if (t % this.gDSz == 0) return !0;
  }
  iOFS(t) {
    if (
      this.isFirstCl(t) ||
      this.isLsCl(t) ||
      this.isFirstRw(t) ||
      this.isLsRw(t)
    )
      return !0;
  }
  isOddCl(t) {
    if (t % (2 * this.gDSz) < this.gDSz) return !0;
  }
  isNOnBRw(t, s) {
    if (t % this.gDSz < this.gDSz - s) return !0;
  }
  isNOnLsCl(t, s) {
    if (t <= this.gDSz * this.gDSz - s * this.gDSz - 1) return !0;
  }
  setInsAPst(t, s) {
    (this.gDIns[t] = { dir: s, clGp: this.saGp }), this.saGp++;
    const i = this.gtTtIx(t, this.gDIns[t].dir);
    this.tgPst.push(this.gDPst[i]);
  }
  fmt(t, s) {
    switch (t) {
      case 'blank':
      default:
        break;
      case 'sides-dn':
        this.isNOnBRw(s, 1) &&
          this.isOddCl(s) &&
          (this.isCld(this.epPst, s) ||
            this.isCld(this.epPst, s + 1) ||
            this.setInsAPst(s, 'dn'));
        break;
      case 'l':
        this.isFirstCl(s) ||
          this.isCld(this.epPst, s) ||
          this.isCld(this.epPst, s - this.gDSz) ||
          this.setInsAPst(s, 'l');
        break;
      case 'dn':
        this.isLsRw(s) ||
          this.isCld(this.epPst, s) ||
          this.isCld(this.epPst, s + 1) ||
          this.setInsAPst(s, 'dn');
        break;
      case 'r':
        this.isLsCl(s) ||
          this.isCld(this.epPst, s) ||
          this.isCld(this.epPst, s + this.gDSz) ||
          this.setInsAPst(s, 'r');
        break;
      case 'dn-r':
        this.isLsRw(s) ||
          this.isLsCl(s) ||
          this.isCld(this.epPst, s) ||
          this.isCld(this.epPst, s + (this.gDSz + 1)) ||
          this.setInsAPst(s, 'dnR');
        break;
      case 'dn-l':
        this.isLsRw(s) ||
          this.isFirstCl(s) ||
          this.isCld(this.epPst, s) ||
          this.isCld(this.epPst, s - (this.gDSz - 1)) ||
          this.setInsAPst(s, 'dnL');
        break;
      case 'dot':
        this.isCld(this.tgPst, s) ||
          this.isCld(this.epPst, s) ||
          (this.dwDo(s), this.epPst.push(this.gDPst[s]));
        break;
      case 'l-cc-dot':
        this.isSqGd(s) && (this.dwLCcDo(s), this.phSqGd(s));
        break;
      case 'double-cc':
        this.isSqGd(s) && (this.dwDuCc(s), this.phSqGd(s));
        break;
      case 'star':
        this.isSqGd(s) && (this.dwSr(s), this.phSqGd(s));
        break;
      case 'sn':
        this.isLSqGd(s) && (this.dwSn(s), this.phLSqGd(s));
        break;
      case 'mo':
        this.isLSqGd(s) && (this.dwMo(s), this.phLSqGd(s));
        break;
      case 'spiral':
        this.isLSqGd(s) && (this.dwSpr(s), this.phLSqGd(s));
        break;
      case 'hz-rt':
        this.isHzRtGd(s) && (this.dwHzRg(s), this.phHzRgGd(s));
        break;
      case 'eye':
        this.isHzRtGd(s) && (this.dwEy(s), this.phHzRgGd(s));
        break;
      case 'infinity':
        this.isHzRtGd(s) && (this.dwIf(s), this.phHzRgGd(s));
        break;
      case 'pr':
        this.isTgGd(s) && (this.dwPy(s), this.phTgGd(s));
        break;
      case 'sp-pr':
        this.isTgGd(s) && (this.dwSpPy(s), this.phTgGd(s));
        break;
      case 'l-pr':
        this.isLTgGd(s) && (this.dwLPy(s), this.phLTgGd(s));
        break;
      case 'l-sp-pr':
        this.isLTgGd(s) && (this.dwLSpPy(s), this.phLTgGd(s));
        break;
      case 'extra-l-pr':
        this.isXLTgGd(s) &&
          (this.dwXLPy(s), this.dwMEy(s + 2 * this.gDSz + 1), this.phXLTgGd(s));
        break;
      case 'bolt':
        this.isBlGd(s) && (this.dwBl(s), this.phBlGd(s));
        break;
      case 'vt-rt':
        this.isVtRgGd(s) && (this.dwVtRg(s), this.phVtRgGd(s));
    }
  }
  isBlGd(t) {
    return !(
      !this.isNOnBRw(t, 2) ||
      !this.isNOnLsCl(t, 1) ||
      this.isCld(this.epPst, t + this.gDSz) ||
      this.isCld(this.tgPst, t + this.gDSz) ||
      this.isCld(this.epPst, t + 1) ||
      this.isCld(this.tgPst, t + 1) ||
      this.isCld(this.epPst, t + this.gDSz + 1) ||
      this.isCld(this.tgPst, t + this.gDSz + 1) ||
      this.isCld(this.epPst, t + 2) ||
      this.isCld(this.tgPst, t + 2)
    );
  }
  phBlGd(t) {
    this.epPst.push(this.gDPst[t + this.gDSz]),
      this.epPst.push(this.gDPst[t + 1]),
      this.epPst.push(this.gDPst[t + this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 2]);
  }
  isTgGd(t) {
    return !(
      !this.isNOnBRw(t, 1) ||
      !this.isNOnLsCl(t, 2) ||
      this.isCld(this.tgPst, t + 1) ||
      this.isCld(this.epPst, t + 1) ||
      this.isCld(this.epPst, t + this.gDSz) ||
      this.isCld(this.tgPst, t + this.gDSz) ||
      this.isCld(this.epPst, t + this.gDSz + 1) ||
      this.isCld(this.tgPst, t + this.gDSz + 1) ||
      this.isCld(this.epPst, t + 2 * this.gDSz + 1) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz + 1)
    );
  }
  isLTgGd(t) {
    return !(
      !this.isNOnBRw(t, 2) ||
      !this.isNOnLsCl(t, 4) ||
      this.isCld(this.tgPst, t + 2) ||
      this.isCld(this.epPst, t + 2) ||
      this.isCld(this.epPst, t + this.gDSz + 1) ||
      this.isCld(this.tgPst, t + this.gDSz + 1) ||
      this.isCld(this.epPst, t + this.gDSz + 2) ||
      this.isCld(this.tgPst, t + this.gDSz + 2) ||
      this.isCld(this.epPst, t + 2 * this.gDSz) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz) ||
      this.isCld(this.epPst, t + 2 * this.gDSz + 1) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz + 1) ||
      this.isCld(this.epPst, t + 2 * this.gDSz + 2) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz + 2) ||
      this.isCld(this.epPst, t + 3 * this.gDSz + 1) ||
      this.isCld(this.tgPst, t + 3 * this.gDSz + 1) ||
      this.isCld(this.epPst, t + 3 * this.gDSz + 2) ||
      this.isCld(this.tgPst, t + 3 * this.gDSz + 2) ||
      this.isCld(this.epPst, t + 4 * this.gDSz + 2) ||
      this.isCld(this.tgPst, t + 4 * this.gDSz + 2)
    );
  }
  isXLTgGd(t) {
    return !(
      !this.isNOnBRw(t, 3) ||
      !this.isNOnLsCl(t, 6) ||
      this.isCld(this.tgPst, t + 3) ||
      this.isCld(this.epPst, t + 3) ||
      this.isCld(this.epPst, t + this.gDSz + 2) ||
      this.isCld(this.tgPst, t + this.gDSz + 2) ||
      this.isCld(this.epPst, t + this.gDSz + 3) ||
      this.isCld(this.tgPst, t + this.gDSz + 3) ||
      this.isCld(this.epPst, t + 2 * this.gDSz + 1) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz + 1) ||
      this.isCld(this.epPst, t + 2 * this.gDSz + 2) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz + 2) ||
      this.isCld(this.epPst, t + 2 * this.gDSz + 3) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz + 3) ||
      this.isCld(this.epPst, t + 3 * this.gDSz) ||
      this.isCld(this.tgPst, t + 3 * this.gDSz) ||
      this.isCld(this.epPst, t + 3 * this.gDSz + 1) ||
      this.isCld(this.tgPst, t + 3 * this.gDSz + 1) ||
      this.isCld(this.epPst, t + 3 * this.gDSz + 2) ||
      this.isCld(this.tgPst, t + 3 * this.gDSz + 2) ||
      this.isCld(this.epPst, t + 3 * this.gDSz + 3) ||
      this.isCld(this.tgPst, t + 3 * this.gDSz + 3) ||
      this.isCld(this.epPst, t + 4 * this.gDSz + 1) ||
      this.isCld(this.tgPst, t + 4 * this.gDSz + 1) ||
      this.isCld(this.epPst, t + 4 * this.gDSz + 2) ||
      this.isCld(this.tgPst, t + 4 * this.gDSz + 2) ||
      this.isCld(this.epPst, t + 4 * this.gDSz + 3) ||
      this.isCld(this.tgPst, t + 4 * this.gDSz + 3) ||
      this.isCld(this.epPst, t + 5 * this.gDSz + 2) ||
      this.isCld(this.tgPst, t + 5 * this.gDSz + 2) ||
      this.isCld(this.epPst, t + 5 * this.gDSz + 3) ||
      this.isCld(this.tgPst, t + 5 * this.gDSz + 3) ||
      this.isCld(this.epPst, t + 6 * this.gDSz + 3) ||
      this.isCld(this.tgPst, t + 6 * this.gDSz + 3)
    );
  }
  phXLTgGd(t) {
    this.epPst.push(this.gDPst[t + 3]),
      this.epPst.push(this.gDPst[t + this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + this.gDSz + 3]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 3]),
      this.epPst.push(this.gDPst[t + 3 * this.gDSz]),
      this.epPst.push(this.gDPst[t + 3 * this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 3 * this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 3 * this.gDSz + 3]),
      this.epPst.push(this.gDPst[t + 4 * this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 4 * this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 4 * this.gDSz + 3]),
      this.epPst.push(this.gDPst[t + 5 * this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 5 * this.gDSz + 3]),
      this.epPst.push(this.gDPst[t + 6 * this.gDSz + 3]);
  }
  phLTgGd(t) {
    this.epPst.push(this.gDPst[t + 2]),
      this.epPst.push(this.gDPst[t + this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 3 * this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 3 * this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 4 * this.gDSz + 2]);
  }
  phTgGd(t) {
    this.epPst.push(this.gDPst[t + 1]),
      this.epPst.push(this.gDPst[t + this.gDSz]),
      this.epPst.push(this.gDPst[t + this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 1]);
  }
  isSqGd(t) {
    return !(
      !this.isNOnBRw(t, 1) ||
      !this.isNOnLsCl(t, 1) ||
      this.isCld(this.tgPst, t) ||
      this.isCld(this.epPst, t) ||
      this.isCld(this.epPst, t + 1) ||
      this.isCld(this.tgPst, t + 1) ||
      this.isCld(this.epPst, t + this.gDSz) ||
      this.isCld(this.tgPst, t + this.gDSz) ||
      this.isCld(this.epPst, t + (this.gDSz + 1)) ||
      this.isCld(this.tgPst, t + (this.gDSz + 1))
    );
  }
  isLSqGd(t) {
    return !(
      !this.isNOnBRw(t, 2) ||
      !this.isNOnLsCl(t, 2) ||
      this.isCld(this.tgPst, t) ||
      this.isCld(this.epPst, t) ||
      this.isCld(this.epPst, t + 1) ||
      this.isCld(this.tgPst, t + 1) ||
      this.isCld(this.epPst, t + this.gDSz) ||
      this.isCld(this.tgPst, t + this.gDSz) ||
      this.isCld(this.epPst, t + 2) ||
      this.isCld(this.tgPst, t + 2) ||
      this.isCld(this.epPst, t + this.gDSz + 2) ||
      this.isCld(this.tgPst, t + this.gDSz + 2) ||
      this.isCld(this.epPst, t + (this.gDSz + 1)) ||
      this.isCld(this.tgPst, t + (this.gDSz + 1)) ||
      this.isCld(this.epPst, t + 2 * this.gDSz) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz) ||
      this.isCld(this.epPst, t + (2 * this.gDSz + 1)) ||
      this.isCld(this.tgPst, t + (2 * this.gDSz + 1)) ||
      this.isCld(this.epPst, t + (2 * this.gDSz + 2)) ||
      this.isCld(this.tgPst, t + (2 * this.gDSz + 2))
    );
  }
  phLSqGd(t) {
    this.epPst.push(this.gDPst[t]),
      this.epPst.push(this.gDPst[t + 1]),
      this.epPst.push(this.gDPst[t + this.gDSz]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz]),
      this.epPst.push(this.gDPst[t + (this.gDSz + 1)]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 2]),
      this.epPst.push(this.gDPst[t + this.gDSz + 2]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 2]);
  }
  phSqGd(t) {
    this.epPst.push(this.gDPst[t]),
      this.epPst.push(this.gDPst[t + 1]),
      this.epPst.push(this.gDPst[t + this.gDSz]),
      this.epPst.push(this.gDPst[t + (this.gDSz + 1)]);
  }
  isVtRgGd(t) {
    return !(
      !this.isNOnBRw(t, 2) ||
      !this.isNOnLsCl(t, 1) ||
      this.isCld(this.tgPst, t) ||
      this.isCld(this.epPst, t) ||
      this.isCld(this.epPst, t + this.gDSz) ||
      this.isCld(this.tgPst, t + this.gDSz) ||
      this.isCld(this.epPst, t + 1) ||
      this.isCld(this.tgPst, t + 1) ||
      this.isCld(this.epPst, t + this.gDSz + 1) ||
      this.isCld(this.tgPst, t + this.gDSz + 1) ||
      this.isCld(this.epPst, t + 2) ||
      this.isCld(this.tgPst, t + 2) ||
      this.isCld(this.epPst, t + this.gDSz + 2) ||
      this.isCld(this.tgPst, t + this.gDSz + 2)
    );
  }
  phVtRgGd(t) {
    this.epPst.push(this.gDPst[t]),
      this.epPst.push(this.gDPst[t + this.gDSz]),
      this.epPst.push(this.gDPst[t + 1]),
      this.epPst.push(this.gDPst[t + this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 2]),
      this.epPst.push(this.gDPst[t + this.gDSz + 2]);
  }
  phHzRgGd(t) {
    this.epPst.push(this.gDPst[t]),
      this.epPst.push(this.gDPst[t + this.gDSz]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz]),
      this.epPst.push(this.gDPst[t + 1]),
      this.epPst.push(this.gDPst[t + this.gDSz + 1]),
      this.epPst.push(this.gDPst[t + 2 * this.gDSz + 1]);
  }
  isHzRtGd(t) {
    return !(
      !this.isNOnBRw(t, 1) ||
      !this.isNOnLsCl(t, 2) ||
      this.isCld(this.tgPst, t) ||
      this.isCld(this.epPst, t) ||
      this.isCld(this.epPst, t + this.gDSz) ||
      this.isCld(this.tgPst, t + this.gDSz) ||
      this.isCld(this.epPst, t + 2 * this.gDSz) ||
      this.isCld(this.tgPst, t + 2 * this.gDSz) ||
      this.isCld(this.epPst, t + 1) ||
      this.isCld(this.tgPst, t + 1) ||
      this.isCld(this.epPst, t + this.gDSz + 1) ||
      this.isCld(this.tgPst, t + this.gDSz + 1) ||
      this.isCld(this.epPst, t + (2 * this.gDSz + 1)) ||
      this.isCld(this.tgPst, t + (2 * this.gDSz + 1))
    );
  }
  isCld(t, s) {
    for (let i = 0; i < t.length; i++)
      if (
        int(t[i].x) == int(this.gDPst[s].x) &&
        int(t[i].y) == int(this.gDPst[s].y)
      )
        return !0;
    return !1;
  }
}
function dwCc(t, s, i) {
  scl(t, s, i, 0.88 * i, R.rnd_dec(2 * PI));
}
function dwLn(t, s, i, h, e, g, l) {
  switch (e) {
    case 'cm':
      null == g && (g = 4), null == l && (l = 4);
      break;
    case 'tn':
      (l = 10), (g = 0.5);
      break;
    default:
      (l = 4), (g = 4);
  }
  const D = glhSt.stkSz / l;
  sl(t, s, i, h, g, M * D), noStroke();
  dist(t, s, i, h);
  for (let e = 0; e < 1; e += 0.25) {
    R.rnd_num(-glhSt.stkSz / 2, glhSt.stkSz / 2),
      R.rnd_num(-glhSt.stkSz / 2, glhSt.stkSz / 2);
    R.rnd_dec() < 0.5 ? fill(glhSt.cnCl) : fill(bgCl);
    lerp(t, i, e), lerp(s, h, e);
  }
  stroke(glhSt.cnCl);
}
class Rdom {
  constructor() {
    this.useA = !1;
    let t = function (t) {
      let s = parseInt(t.substr(0, 8, 16)),
        i = parseInt(t.substr(8, 8, 16)),
        h = parseInt(t.substr(16, 8, 16)),
        e = parseInt(t.substr(24, 8, 16));
      return function () {
        (s |= 0), (i |= 0), (h |= 0), (e |= 0);
        let t = (((s + i) | 0) + e) | 0;
        return (
          (e = (e + 1) | 0),
          (s = i ^ (i >>> 9)),
          (i = (h + (h << 3)) | 0),
          (h = (h << 21) | (h >>> 11)),
          (h = (h + t) | 0),
          (t >>> 0) / 4294967296
        );
      };
    };
    (this.prngA = new t(tokenData.hash.substr(2, 32))),
      (this.prngB = new t(tokenData.hash.substr(34, 32)));
    for (let t = 0; t < 1e6; t += 2) this.prngA(), this.prngB();
  }
  rnd_dec() {
    return (this.useA = !this.useA), this.useA ? this.prngA() : this.prngB();
  }
  rnd_num(t, s) {
    return t + (s - t) * this.rnd_dec();
  }
  rnd_int(t, s) {
    return Math.floor(this.rnd_num(t, s + 1));
  }
  rnd_bool(t) {
    return this.rnd_dec() < t;
  }
  rnd_chc(t) {
    return t[this.rnd_int(0, t.length - 1)];
  }
}
function chw(t) {
  let s = 0;
  for (let i = 0; i < t.length; i++) s += t[i].weight;
  let i = R.rnd_num(0, s);
  for (let s = 0; s < t.length; s++) {
    let h = t[s];
    if (h.weight >= i) return h.value;
    i -= h.weight;
  }
}
function slp(t) {
  let s,
    i,
    h,
    e,
    g,
    l,
    D = { fs: { x: 0, y: 1 } },
    P = 1,
    n = 1;
  D.fs.nx = { x: 1, y: 1 };
  for (let d = 0; d < t; d++)
    for (s = D.fs; null != s.nx; ) {
      (i = s.nx),
        (l = 0.33 + R.rnd_dec() * (1 - 0.66)),
        (e = s.x + l * (i.x - s.x)),
        (h = l < 0.5 ? e - s.x : i.x - e),
        (g = 0.5 * (s.y + i.y)),
        (g += h * (2 * R.rnd_dec() - 1));
      let t = { x: e, y: g };
      g < P ? (P = g) : g > n && (n = g), (t.nx = i), (s.nx = t), (s = i);
    }
  if (n != P) {
    let t = 1 / (n - P);
    for (s = D.fs; null != s; ) (s.y = t * (s.y - P)), (s = s.nx);
  } else for (s = D.fs; null != s; ) (s.y = 1), (s = s.nx);
  return D;
}
function scl(t, s, i, h, e, g, l) {
  let D, P, n, d, a;
  null == g && (g = TWO_PI),
    null == l && (l = 5),
    (D = slp(l).fs),
    (n = e),
    (P = i + D.y * (h - i)),
    (d = t + P * Math.cos(n)),
    (a = s + P * Math.sin(n));
  let r = d,
    S = a;
  for (; null != D.nx; )
    (D = D.nx),
      (n = g * D.x + e),
      (P = i + D.y * (h - i)),
      (d = t + P * Math.cos(n)),
      (a = s + P * Math.sin(n)),
      dwLn(r, S, d, a, 'tn'),
      (r = d),
      (S = a);
}
function sl(t, s, i, h, e, g) {
  let l,
    D,
    P,
    n,
    d = slp(e);
  for (
    noFill(), beginShape(), l = d.fs, D = l.y, curveVertex(t, s);
    null != l;

  )
    (P = t + (i - t) * l.x),
      (n = s + (h - s) * l.x),
      (P += R.rnd_dec() * g * (l.y - D)),
      (n += R.rnd_dec() * g * (l.y - D)),
      curveVertex(P, n),
      (l = l.nx);
  curveVertex(i, h), endShape();
}
function gnl(t) {
  loadPixels();
  const s = pixelDensity(),
    i = width * s * 4 * (height * s);
  for (let s = 0; s < i; s += 4) {
    const i = random(-t, t);
    (pixels[s] = pixels[s] + i),
      (pixels[s + 1] = pixels[s + 1] + i),
      (pixels[s + 2] = pixels[s + 2] + i);
  }
  updatePixels();
}
