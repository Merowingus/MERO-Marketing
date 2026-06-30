"use client";

import { useEffect } from "react";
import { dashboardData } from "@/lib/dashboard-data";
import { createClient } from "@/lib/supabase/client";

const SHELL_HTML = `
  <div class="shell">
    <div class="topbar">
      <a class="studio-brand" href="https://www.merowingus.com/" target="_blank" rel="noreferrer">
        <img class="topbar-logo theme-logo" data-theme-logo src="assets/logo.png" alt="Merowingus Studio logo" />
        <span>Merowingus <span>Studio</span></span>
      </a>
      <div class="topbar-actions">
        <a class="navlink" href="https://www.merowingus.com/" target="_blank" rel="noreferrer">Studio site</a>
        <button class="navlink" id="signout" type="button">Log out</button>
        <button class="theme-toggle" id="theme-toggle" type="button" aria-label="Switch dashboard theme" aria-pressed="false">
          <span class="theme-toggle-dot" aria-hidden="true"></span>
          <span id="theme-label">Dark</span>
        </button>
      </div>
    </div>

    <header class="hero">
      <div class="brand-lockup">
        <img id="brand-logo" class="brand-logo theme-logo" data-theme-logo src="assets/logo.png" alt="Merowingus Studio logo" />
        <div>
          <div class="eyebrow">Merowingus Studio · MERO Marketing</div>
          <h1 id="dashboard-title">Command Center</h1>
          <p id="dashboard-subtitle" class="lead"></p>
        </div>
      </div>
      <aside class="hero-card">
        <span class="pill pill-live" id="campaign-status">Launch in progress</span>
        <p id="campaign-focus"></p>
        <a id="campaign-website" class="button" href="#" target="_blank" rel="noreferrer">Open product</a>
      </aside>
    </header>

    <main>
      <section class="focus-strip" id="focus-strip" aria-label="Current focus"></section>

      <section class="section grid-main">
        <article class="card span-2">
          <div class="card-head">
            <div>
              <div class="eyebrow">Signal map</div>
              <h2>How launch attention should become play</h2>
            </div>
            <span class="pill pill-running">Data-driven shell</span>
          </div>
          <div class="signal-map" id="signal-map"></div>
        </article>

        <aside class="card">
          <div class="eyebrow">Analytics readiness</div>
          <h2>GA4 setup</h2>
          <div class="ring-card" id="ga4-ring"></div>
        </aside>
      </section>

      <section class="section grid-main">
        <article class="card span-2">
          <div class="card-head">
            <div>
              <div class="eyebrow">Data visualization</div>
              <h2>Channel status mix</h2>
            </div>
            <span class="pill pill-watch">Studio chart tokens</span>
          </div>
          <div class="bar-list" id="channel-status-bars"></div>
        </article>

        <aside class="card">
          <div class="eyebrow">Pipeline</div>
          <h2>Update path</h2>
          <div class="pipeline-list" id="update-pipeline"></div>
        </aside>
      </section>

      <section class="section">
        <div class="section-head">
          <div>
            <div class="eyebrow">Pulse</div>
            <h2>Launch state</h2>
          </div>
          <span id="last-updated" class="muted"></span>
        </div>
        <div class="kpi-grid" id="kpi-grid"></div>
      </section>

      <section class="section">
        <div class="section-head">
          <div>
            <div class="eyebrow">Channels</div>
            <h2>What each wheel is doing</h2>
          </div>
        </div>
        <div class="channel-grid" id="channel-grid"></div>
      </section>

      <section class="section grid-main">
        <article class="card span-2">
          <div class="card-head">
            <div>
              <div class="eyebrow">TikTok</div>
              <h2>First launch batch</h2>
            </div>
            <span class="pill pill-running">24–72h observation</span>
          </div>
          <div class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Video</th>
                  <th>Hook</th>
                  <th>Views</th>
                  <th>Likes</th>
                  <th>Comments</th>
                  <th>Profile</th>
                  <th>Clicks</th>
                  <th>Signups</th>
                </tr>
              </thead>
              <tbody id="tiktok-table"></tbody>
            </table>
          </div>
        </article>

        <aside class="card">
          <div class="eyebrow">Next 72 hours</div>
          <h2>Do next</h2>
          <ul class="action-list" id="next-actions"></ul>
        </aside>
      </section>

      <section class="section grid-main">
        <article class="card span-2">
          <div class="card-head">
            <div>
              <div class="eyebrow">Experiments</div>
              <h2>Hypotheses in motion</h2>
            </div>
            <span class="pill pill-watch">Manual results</span>
          </div>
          <div class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Experiment</th>
                  <th>Channel</th>
                  <th>Hypothesis</th>
                  <th>Metric</th>
                  <th>Verdict</th>
                </tr>
              </thead>
              <tbody id="experiment-table"></tbody>
            </table>
          </div>
        </article>

        <aside class="card danger-card">
          <div class="eyebrow">Focus guard</div>
          <h2>Do not do yet</h2>
          <ul class="plain-list" id="dont-do-list"></ul>
        </aside>
      </section>

      <section class="section grid-main">
        <article class="card">
          <div class="eyebrow">Analytics</div>
          <h2>GA4 setup checklist</h2>
          <ul class="check-list" id="ga4-checklist"></ul>
        </article>

        <article class="card">
          <div class="eyebrow">Events</div>
          <h2>What to track</h2>
          <div class="event-columns">
            <div>
              <h3>Recommended events</h3>
              <div id="recommended-events" class="tag-cloud"></div>
            </div>
            <div>
              <h3>Key events</h3>
              <div id="key-events" class="tag-cloud"></div>
            </div>
          </div>
        </article>

        <article class="card">
          <div class="eyebrow">Links</div>
          <h2>UTM and routing</h2>
          <div id="link-list" class="link-list"></div>
        </article>
      </section>
    </main>
  </div>
`;

export default function DashboardClient() {
  useEffect(() => {
    const data: any = dashboardData;
    const $ = (id: string) => document.getElementById(id) as HTMLElement;

    const toneClass = (tone?: string) => `pill pill-${tone || "watch"}`;
    const cell = (value: any) => `<td>${value || "pending"}</td>`;
    const tag = (name: string) => `<span class="tag">${name}</span>`;

    const themeToggle = $("theme-toggle");
    const themeLabel = $("theme-label");

    function applyTheme(theme: string) {
      const safeTheme = theme === "dark" ? "dark" : "light";
      document.documentElement.dataset.theme = safeTheme;
      document.querySelectorAll("[data-theme-logo]").forEach((logo) => {
        (logo as HTMLImageElement).src =
          safeTheme === "dark" ? "assets/logo-dark.png" : "assets/logo.png";
      });
      themeToggle.setAttribute(
        "aria-pressed",
        safeTheme === "dark" ? "true" : "false",
      );
      themeLabel.textContent = safeTheme === "dark" ? "Light" : "Dark";
      try {
        localStorage.setItem("mero-dashboard-theme", safeTheme);
      } catch {
        // localStorage may be unavailable; theme still works for this session.
      }
    }

    if (!themeToggle.dataset.bound) {
      themeToggle.addEventListener("click", () => {
        const nextTheme =
          document.documentElement.dataset.theme === "dark" ? "light" : "dark";
        applyTheme(nextTheme);
      });
      themeToggle.dataset.bound = "1";
    }

    const signout = $("signout");
    if (signout && !signout.dataset.bound) {
      signout.addEventListener("click", async () => {
        await createClient().auth.signOut();
        window.location.href = "/login";
      });
      signout.dataset.bound = "1";
    }

    function countBy(items: any[], key: string) {
      return items.reduce((acc: any, item: any) => {
        const value = item[key] || "unknown";
        acc[value] = (acc[value] || 0) + 1;
        return acc;
      }, {});
    }

    function renderBars(targetId: string, rows: any[]) {
      const max = Math.max(...rows.map((row) => row.value), 1);
      $(targetId).innerHTML = rows
        .map(
          (row, index) => `
            <div class="bar-row">
              <div class="bar-row-head">
                <span>${row.label}</span>
                <b>${row.value}</b>
              </div>
              <div class="bar-track">
                <span class="bar-fill chart-${(index % 8) + 1}" style="width:${Math.round(
                  (row.value / max) * 100,
                )}%"></span>
              </div>
            </div>
          `,
        )
        .join("");
    }

    function renderRing(
      targetId: string,
      completed: number,
      total: number,
      label: string,
      detail: string,
    ) {
      const safeTotal = Math.max(total, 1);
      const percent = Math.round((completed / safeTotal) * 100);
      $(targetId).innerHTML = `
        <div class="ring" style="--ring-value:${percent}">
          <span>${completed}/${total}</span>
        </div>
        <div>
          <p class="ring-label">${label}</p>
          <p class="ring-detail">${detail}</p>
        </div>
      `;
    }

    document.title = `${data.campaign.product} · ${data.campaign.title}`;
    $("dashboard-title").textContent = data.campaign.title;
    $("dashboard-subtitle").textContent = data.campaign.subtitle;
    $("campaign-status").textContent = data.campaign.status;
    $("campaign-focus").textContent = data.campaign.currentFocus;
    ($("campaign-website") as HTMLAnchorElement).href = data.campaign.website;
    $("last-updated").textContent = `Last updated ${data.campaign.lastUpdated}`;

    $("focus-strip").innerHTML = data.focus
      .map(
        (item: any) => `
        <div class="focus-item">
          <span>${item.label}</span>
          <b class="${toneClass(item.tone)}">${item.value}</b>
        </div>
      `,
      )
      .join("");

    $("signal-map").innerHTML = data.signalMap
      .map(
        (node: any, index: number) => `
        <div class="signal-node">
          <span class="${toneClass(node.tone)}">${node.label}</span>
          <h3>${node.title}</h3>
          <p>${node.detail}</p>
          ${index < data.signalMap.length - 1 ? '<i class="signal-arrow">→</i>' : ""}
        </div>
      `,
      )
      .join("");

    const ga4Started = data.ga4.checklist.filter((item: any) =>
      ["done", "running", "partial"].includes(item.done),
    ).length;
    renderRing(
      "ga4-ring",
      ga4Started,
      data.ga4.checklist.length,
      "setup items started",
      "Live API integration comes later. This ring only shows current setup readiness.",
    );

    const channelStatusCounts = countBy(data.channels, "status");
    renderBars(
      "channel-status-bars",
      Object.entries(channelStatusCounts).map(([label, value]) => ({
        label,
        value,
      })),
    );

    $("update-pipeline").innerHTML = data.dataViz.updatePipeline
      .map(
        (item: any) => `
        <div class="pipeline-item">
          <span class="${toneClass(item.tone)}">${item.status}</span>
          <p>${item.label}</p>
        </div>
      `,
      )
      .join("");

    $("kpi-grid").innerHTML = data.kpis
      .map(
        (item: any) => `
        <article class="kpi-card">
          <span class="${toneClass(item.tone)}">${item.label}</span>
          <strong>${item.value}</strong>
          <p>${item.detail}</p>
        </article>
      `,
      )
      .join("");

    $("channel-grid").innerHTML = data.channels
      .map(
        (channel: any) => `
        <article class="channel-card">
          <div class="card-head">
            <h3>${channel.name}</h3>
            <span class="${toneClass(channel.tone)}">${channel.status}</span>
          </div>
          <p class="role">${channel.role}</p>
          <p><b>Next:</b> ${channel.next}</p>
          <p class="metric"><b>Metric:</b> ${channel.metric}</p>
        </article>
      `,
      )
      .join("");

    $("tiktok-table").innerHTML = data.tiktokVideos
      .map(
        (video: any) => `
        <tr>
          <td><b>${video.name}</b><small>${video.note}</small></td>
          <td>${video.hook}</td>
          ${cell(video.views)}
          ${cell(video.likes)}
          ${cell(video.comments)}
          ${cell(video.profileVisits)}
          ${cell(video.websiteClicks)}
          ${cell(video.signups)}
        </tr>
      `,
      )
      .join("");

    $("experiment-table").innerHTML = data.experiments
      .map(
        (experiment: any) => `
        <tr>
          <td>${experiment.date}</td>
          <td><b>${experiment.name}</b></td>
          <td>${experiment.channel}</td>
          <td>${experiment.hypothesis}</td>
          <td>${experiment.metric}</td>
          <td><span class="${toneClass(
            experiment.verdict === "parked"
              ? "parked"
              : experiment.verdict === "planned"
                ? "next"
                : "running",
          )}">${experiment.verdict}</span></td>
        </tr>
      `,
      )
      .join("");

    $("next-actions").innerHTML = data.nextActions
      .map(
        (action: any) => `
        <li>
          <span class="${toneClass(action.status)}">${action.label}</span>
          <p>${action.detail}</p>
        </li>
      `,
      )
      .join("");

    $("dont-do-list").innerHTML = data.dontDoYet
      .map((item: any) => `<li>${item}</li>`)
      .join("");

    $("ga4-checklist").innerHTML = data.ga4.checklist
      .map(
        (item: any) => `
        <li>
          <span class="check-dot check-${item.done}"></span>
          <span>${item.item}</span>
          <b>${item.done}</b>
        </li>
      `,
      )
      .join("");

    $("recommended-events").innerHTML = data.ga4.recommendedEvents
      .map(tag)
      .join("");
    $("key-events").innerHTML = data.ga4.keyEvents.map(tag).join("");

    $("link-list").innerHTML = data.links
      .map(
        (link: any) => `
        <div class="link-row">
          <span>${link.label}</span>
          <code>${link.value}</code>
        </div>
      `,
      )
      .join("");

    const savedTheme =
      (() => {
        try {
          return localStorage.getItem("mero-dashboard-theme");
        } catch {
          return null;
        }
      })() === "dark"
        ? "dark"
        : "light";
    applyTheme(savedTheme);
  }, []);

  return <div dangerouslySetInnerHTML={{ __html: SHELL_HTML }} />;
}
