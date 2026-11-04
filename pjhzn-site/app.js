const pages = [
  {
    sectionId: "home",
    idCode: "HZN-P01",
    shortLabel: "01. Home",
    pageName: "Shared Homepage",
    assetId: "IMG-HERO-01",
    assetName: "Shared Hybrid Arched Entry - Open Path",
    contrast: "14.03:1 (Pass AAA)",
    heroPath: "./assets/IMG-HERO-01.webp",
    heroLabel: "arch entry modern interior",
    bodyBlurb: "Dual-entity shared architecture. A single threshold serving two distinct missions — Project Horizon and Horizon Family Services — unified by spatial continuity.",
    heroDesc: "A single threshold serving two distinct missions — Project Horizon and Horizon Family Services — unified by spatial continuity. The arched entry signals openness while the interior sightline separates teal (non-profit) and copper (clinical) wayfinding."
  },
  {
    sectionId: "about",
    idCode: "HZN-P02",
    shortLabel: "02. About Us",
    pageName: "About Us",
    assetId: "IMG-ABT-01",
    assetName: "Welcoming Facility Entrance - Warm Wood",
    contrast: "12.25:1 (Pass AAA)",
    heroPath: "./assets/IMG-ABT-01.webp",
    heroLabel: "welcoming entrance warm wood paneling",
    bodyBlurb: "Transitional Spatial Gallery. Documenting the journey from street to support — wood, light, and threshold as care infrastructure.",
  },
  {
    sectionId: "project-horizon",
    idCode: "HZN-P03",
    shortLabel: "03. Project Horizon",
    pageName: "Project Horizon",
    assetId: "IMG-NP-HERO",
    assetName: "Deep Teal Non-Profit Hub",
    contrast: "10.57:1 (Pass AAA)",
    heroPath: "./assets/IMG-NP-HERO.webp",
    heroLabel: "community room teal pendants",
    entityColor: "#0A4D4E",
    entityLabel: "Deep Teal Non-Profit Hub",
    bodyBlurb: "Non-profit core: housing stability, resource navigation, and community building. Teal anchors trust, depth, and continuity.",
    cards: [
      { id: "IMG-NP-PRG01", img: "./assets/IMG-NP-PRG01.webp", title: "Transitional Housing", desc: "Stabilized residential living with trauma-informed spatial design. Private, dignified, light-filled." },
      { id: "IMG-NP-PRG02", img: "./assets/IMG-NP-PRG02.webp", title: "Resource & Learning Hub", desc: "Learn / Create stacks. Open shelves, mentorship tables, and pathways to employment and education." },
    ],
  },
  {
    sectionId: "horizon-family-services",
    idCode: "HZN-P04",
    shortLabel: "04. Family Services",
    pageName: "Horizon Family Services",
    assetId: "IMG-FP-HERO",
    assetName: "Warm Copper Clinical Hub",
    contrast: "8.18:1 (Pass AAA)",
    heroPath: "./assets/IMG-FP-HERO.webp",
    heroLabel: "copper reception tranquil healthcare",
    entityColor: "#8C4A27",
    entityLabel: "Warm Copper Clinical Hub",
    bodyBlurb: "Clinical counterpart: outpatient, family therapy, and case coordination — warmth as clinical tool.",
    cards: [
      { id: "IMG-FP-PRG01", img: "./assets/IMG-FP-PRG01.webp", title: "Outpatient Consult", desc: "Warm, approachable medical consultation office. Low barrier, high dignity intake environment." },
      { id: "IMG-FP-PRG02", img: "./assets/IMG-FP-PRG02.webp", title: "Therapy Commons", desc: "Fireplace, bouclé chairs, and soft enclosure. Family systems work in a residential, not institutional, setting." },
    ],
  },
  {
    sectionId: "programs",
    idCode: "HZN-P05",
    shortLabel: "05. Our Programs",
    pageName: "Our Programs",
    assetId: "IMG-DIR-CAT01",
    assetName: "Abstract Growth Corridor",
    contrast: "6.87:1 (Pass AA)",
    heroPath: "./assets/IMG-DIR-CAT01.webp",
    heroLabel: "staircase abstract growth corridor",
    bodyBlurb: "Structured Program Directory. Cataloguing intervention pathways — housing, clinical, workforce — as a navigable system.",
  },
  {
    sectionId: "leadership",
    idCode: "HZN-P06",
    shortLabel: "06. Leadership",
    pageName: "Leadership",
    assetId: "IMG-LEAD-01",
    assetName: "Executive Governance Backdrop",
    contrast: "10.91:1 (Pass AAA)",
    heroPath: "./assets/IMG-LEAD-01.webp",
    heroLabel: "executive conference room",
    bodyBlurb: "Executive Governance. Board stewardship and cross-entity leadership, rendered in quiet material authority.",
  },
  {
    sectionId: "careers",
    idCode: "HZN-P07",
    shortLabel: "07. Careers",
    pageName: "Careers",
    assetId: "IMG-CAR-01",
    assetName: "Collaborative Workspace Culture",
    contrast: "12.25:1 (Pass AAA)",
    heroPath: "./assets/IMG-CAR-01.webp",
    heroLabel: "collaborative workspace culture",
    bodyBlurb: "Talent & Application Hub. Culture of practice: supervision, peer consultation, and lived-experience centered hiring.",
  },
  {
    sectionId: "contact",
    idCode: "HZN-P08",
    shortLabel: "08. Contact",
    pageName: "Contact",
    assetId: "IMG-ABT-01",
    assetName: "General Inquiry Routing - Warm Entry",
    contrast: "14.03:1 (Pass AAA)",
    heroPath: "./assets/IMG-ABT-01.webp",
    heroLabel: "welcoming entrance reused",
    bodyBlurb: "General inquiry routing with entity-aware triage. One front door, intelligent internal routing to teal or copper.",
  },
  {
    sectionId: "privacy",
    idCode: "HZN-P09",
    shortLabel: "09. Privacy Policy",
    pageName: "Privacy Policy",
    assetId: "IMG-HERO-01",
    assetName: "Data Handling Transparency",
    contrast: "14.03:1 (Pass AAA)",
    heroPath: "./assets/IMG-HERO-01.webp",
    heroLabel: "arched entry reused privacy",
    bodyBlurb: "Data Handling Transparency. HIPAA-aware, non-profit governance — plain language privacy for vulnerable populations.",
  },
];

let currentId = location.hash ? location.hash.replace("#","") : "home";
if (!pages.find(p=>p.sectionId===currentId)) currentId="home";
let viewMode = "desktop";

const navList = document.getElementById("nav-list");
const navMobile = document.getElementById("nav-mobile");
const btnDesktop = document.getElementById("btn-desktop");
const btnMobile = document.getElementById("btn-mobile");
const stageWrapper = document.getElementById("stage-wrapper");

function renderNav(){
  navList.innerHTML = "";
  navMobile.innerHTML = "";
  pages.forEach(p=>{
    const li = document.createElement("li");
    const btn = document.createElement("button");
    btn.className = "nav-btn" + (p.sectionId===currentId ? " active" : "");
    btn.innerHTML = `<span>${p.shortLabel}</span><span class="code">${p.idCode}</span>`;
    btn.addEventListener("click",()=>navigate(p.sectionId));
    li.appendChild(btn);
    navList.appendChild(li);

    const li2 = document.createElement("li");
    const b2 = document.createElement("button");
    b2.textContent = p.shortLabel;
    b2.className = p.sectionId===currentId ? "active" : "";
    b2.addEventListener("click",()=>navigate(p.sectionId));
    li2.appendChild(b2);
    navMobile.appendChild(li2);
  });
}

function navigate(id){
  currentId = id;
  location.hash = id;
  render();
}

function renderStage(){
  const p = pages.find(x=>x.sectionId===currentId) || pages[0];
  // header stage bar
  document.getElementById("stage-dot").style.background = p.entityColor || "#147375";
  document.getElementById("stage-page").textContent = "/ " + p.pageName;
  // hero
  const heroImg = document.getElementById("hero-img");
  heroImg.src = p.heroPath;
  heroImg.alt = p.assetName;
  document.getElementById("hero-kicker").textContent = `${p.idCode} · ${p.assetId}`;
  document.getElementById("hero-title").textContent = p.pageName;
  const entityEl = document.getElementById("hero-entity");
  if(p.entityLabel){
    entityEl.style.display = "inline-flex";
    entityEl.querySelector("span").textContent = p.entityLabel;
    entityEl.querySelectorAll("i").forEach(i=>i.style.background = p.entityColor);
  } else {
    entityEl.style.display = "none";
  }
  document.getElementById("hero-blurb").textContent = p.bodyBlurb;
  document.getElementById("hero-asset-label").textContent = "Asset: " + p.heroLabel;

  // content
  const content = document.getElementById("stage-content");
  if(p.cards){
    content.innerHTML = `
      <div class="program-head">
        <h2>Program Artifacts · ${p.idCode}</h2>
        <span>2 linked photographic assets</span>
      </div>
      <div class="card-grid">
        ${p.cards.map(c=>`
          <div class="prog-card">
            <div class="prog-media">
              <img src="${c.img}" alt="${c.title}" loading="lazy">
              <span class="prog-badge">${c.id}</span>
            </div>
            <div class="prog-body">
              <h3>${c.title}</h3>
              <p>${c.desc}</p>
              <div class="prog-entity"><i style="background:${p.entityColor}"></i> ${p.entityLabel}</div>
            </div>
          </div>
        `).join("")}
      </div>
      <div class="entity-note">
        <div class="entity-note-icon" style="background:${p.entityColor}14;color:${p.entityColor}">✦</div>
        <div>
          <h4>Entity Theming Applied</h4>
          <p>${p.entityLabel} uses ${p.entityColor} as primary — contrast ${p.contrast} verified for hero scrim.</p>
        </div>
      </div>
    `;
  } else {
    content.innerHTML = `
      <div class="content-max">
        <div style="display:flex;gap:12px;align-items:center;margin-bottom:20px">
          <span class="meta-pill">${p.idCode} Content Wire</span>
          <span style="font-size:11px;color:#8b9bb0">${p.assetId} · ${p.contrast}</span>
        </div>
        <div class="content-grid">
          <div>
            <div class="info-card">
              <h3 class="content-h3">Page Narrative — ${p.pageName}</h3>
              <p>${p.bodyBlurb} This screen establishes hierarchy, photographic direction, and accessible color pairing for production handoff. Touch targets enforced at ≥44px, scrim ensures 14:1 contrast on hero type.</p>
              <div style="height:1px;background:#eef2f5;margin-top:16px"></div>
              <div style="display:flex;flex-wrap:wrap;gap:8px;margin-top:16px">
                ${[`Hero: ${p.assetId}`, `Scrim: rgba(15,23,30,0.88)`, `Type: Cinzel + Jakarta Sans`, `Contrast: ${p.contrast}`].map(t=>`<span class="chip">${t}</span>`).join("")}
              </div>
            </div>
            <div class="block-grid">
              ${[1,2,3].map(i=>`
                <div class="mini-card">
                  <div class="bar"></div>
                  <div class="bar short"></div>
                  <div class="placeholder">BLOCK ${i}</div>
                </div>
              `).join("")}
            </div>
          </div>
          <div>
            <div class="info-card" style="padding:0;overflow:hidden">
              <div style="aspect-ratio:4/3;background:#eef2f5;position:relative;overflow:hidden">
                <img src="${p.heroPath}" alt="${p.assetName}" style="width:100%;height:100%;object-fit:cover;opacity:.9">
                <div style="position:absolute;inset:0;background:linear-gradient(180deg, rgba(0,0,0,0) 40%, rgba(15,23,30,.72) 100%)"></div>
                <div style="position:absolute;bottom:10px;left:10px;right:10px;color:white">
                  <div style="font-size:10px;font-weight:700;letter-spacing:.08em;opacity:.8">${p.assetId}</div>
                  <div style="font-size:12px;font-weight:600;margin-top:2px">${p.assetName}</div>
                </div>
              </div>
              <div style="padding:12px">
                <div style="font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:#5b6d7f">Mapped Asset Detail</div>
                <div style="font-size:12px;color:#3b4a5a;margin-top:6px;line-height:1.5">${p.heroLabel} — pre-production mockup approved for ${p.idCode}.</div>
              </div>
            </div>
            <div style="background:#0f1720;border-radius:10px;padding:16px;color:white;margin-top:16px">
              <div style="font-size:11px;font-weight:700;letter-spacing:.12em;text-transform:uppercase;opacity:.6">QA Checklist</div>
              <ul style="margin:10px 0 0;padding:0;list-style:none;font-size:12px;line-height:1.6;display:flex;flex-direction:column;gap:6px">
                <li style="display:flex;gap:8px"><span style="color:#34d399">✓</span> Touch target ≥44×44px enforced</li>
                <li style="display:flex;gap:8px"><span style="color:#34d399">✓</span> Contrast ${p.contrast}</li>
                <li style="display:flex;gap:8px"><span style="color:#34d399">✓</span> Scrim rgba(15,23,30,0.88) applied</li>
                <li style="display:flex;gap:8px"><span style="color:#34d399">✓</span> Cinzel H1 + Jakarta body</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  document.getElementById("footer-meta").textContent = `© Project Horizon · ${p.idCode} · HZN-DESIGN-001`;

  // right inspector
  document.getElementById("meta-id").textContent = p.idCode;
  document.getElementById("meta-name").textContent = p.pageName;
  document.getElementById("meta-asset-name").textContent = p.assetName;
  document.getElementById("meta-asset-id").textContent = p.assetId;
  document.getElementById("meta-contrast").textContent = p.contrast;
  document.getElementById("meta-asset-img").src = p.heroPath;
  document.getElementById("meta-asset-img").alt = p.assetName;
  document.getElementById("meta-asset-label").textContent = p.heroLabel;
  const entityRow = document.getElementById("meta-entity-row");
  if(p.entityColor){
    entityRow.style.display = "flex";
    document.querySelector("#meta-entity-color .color-chip").style.background = p.entityColor;
    document.querySelector("#meta-entity-color span").textContent = p.entityColor;
  } else {
    entityRow.style.display = "none";
  }

  const linked = document.getElementById("linked-assets");
  if(p.cards){
    linked.innerHTML = p.cards.map(c=>`
      <div class="linked-card">
        <img src="${c.img}" alt="${c.title}">
        <div class="cap"><div class="id">${c.id}</div><div class="title">${c.title}</div></div>
      </div>
    `).join("");
    linked.style.display = "grid";
  } else {
    linked.innerHTML = "";
    linked.style.display = "none";
  }
}

function render(){
  renderNav();
  renderStage();
  // update active states
  document.querySelectorAll(".nav-btn").forEach(b=>{
    const isActive = b.textContent.includes(pages.find(p=>p.sectionId===currentId).idCode);
  });
}

function setMode(mode){
  viewMode = mode;
  if(mode==="desktop"){
    stageWrapper.classList.remove("mobile");
    stageWrapper.style.width = "100%";
    btnDesktop.classList.add("active");
    btnDesktop.setAttribute("aria-pressed","true");
    btnMobile.classList.remove("active");
    btnMobile.setAttribute("aria-pressed","false");
  } else {
    stageWrapper.classList.add("mobile");
    btnMobile.classList.add("active");
    btnMobile.setAttribute("aria-pressed","true");
    btnDesktop.classList.remove("active");
    btnDesktop.setAttribute("aria-pressed","false");
  }
}

btnDesktop.addEventListener("click",()=>setMode("desktop"));
btnMobile.addEventListener("click",()=>setMode("mobile"));
window.addEventListener("hashchange",()=>{
  const h = location.hash.replace("#","");
  if(pages.find(p=>p.sectionId===h)) { currentId=h; render(); }
});

// keyboard
document.addEventListener("keydown",e=>{
  if(e.key==="ArrowRight"||e.key==="ArrowLeft"){
    const idx = pages.findIndex(p=>p.sectionId===currentId);
    const next = e.key==="ArrowRight" ? (idx+1)%pages.length : (idx-1+pages.length)%pages.length;
    navigate(pages[next].sectionId);
  }
});

render();
setMode("desktop");

// expose for debug
window.HORIZON = { pages, navigate, setMode };
