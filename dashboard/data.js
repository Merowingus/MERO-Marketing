window.dashboardData = {
  campaign: {
    product: "Divergentum",
    title: "MERO Marketing Command Center",
    subtitle: "Launch view for Reddit, TikTok, experiments, and analytics readiness.",
    status: "Launch in progress",
    lastUpdated: "2026-06-27",
    owner: "Mykola · Merowingus Studio",
    website: "https://www.divergentum.com/",
    profileUtm:
      "https://www.divergentum.com/?utm_source=tiktok&utm_medium=social&utm_campaign=profile",
    currentFocus:
      "Reddit foundation is live. First TikTok launch batch is uploaded and waiting for 24–72h signals. Next: capture metrics, then build the dashboard into the Studio flow."
  },

  focus: [
    { label: "Reddit foundation", value: "Live", tone: "live" },
    { label: "TikTok batch", value: "Running", tone: "running" },
    { label: "GA4", value: "Basic setup", tone: "watch" },
    { label: "Dashboard", value: "MVP now", tone: "next" },
    { label: "PH / HN", value: "Parked", tone: "parked" }
  ],

  kpis: [
    {
      label: "TikTok videos uploaded",
      value: "7",
      detail: "classes, races/portraits, gameplay",
      tone: "live"
    },
    {
      label: "Running experiments",
      value: "4",
      detail: "Reddit, TikTok, blog, class gallery",
      tone: "running"
    },
    {
      label: "Active channels",
      value: "2",
      detail: "Reddit + TikTok",
      tone: "running"
    },
    {
      label: "Website link",
      value: "Pending",
      detail: "waiting for TikTok Website field",
      tone: "watch"
    },
    {
      label: "GA4 state",
      value: "Basic",
      detail: "needs key events + UTM review",
      tone: "watch"
    }
  ],

  signalMap: [
    {
      label: "Reddit",
      title: "Community proof",
      detail: "Subreddit foundation is live. External DevLog waits for the right moment.",
      tone: "live"
    },
    {
      label: "TikTok",
      title: "Visual reach",
      detail: "Seven launch videos are uploaded. Metrics are in the first observation window.",
      tone: "running"
    },
    {
      label: "Website",
      title: "Traffic capture",
      detail: "Profile link is pending until TikTok unlocks the Website field.",
      tone: "watch"
    },
    {
      label: "Sign up",
      title: "Conversion",
      detail: "GA4 needs sign_up as a key event and UTM review.",
      tone: "watch"
    },
    {
      label: "Activation",
      title: "First real play",
      detail: "session_5_turns / activation event is planned.",
      tone: "next"
    }
  ],

  channels: [
    {
      name: "Reddit",
      role: "Trust + high-intent community",
      status: "Live",
      tone: "live",
      next: "Keep subreddit warm, answer comments, prepare one non-duplicate external DevLog post.",
      metric: "comments, profile visits, signups via UTM"
    },
    {
      name: "TikTok",
      role: "Visual proof + fast reach",
      status: "Running",
      tone: "running",
      next: "Wait 24–72h, capture views/retention/comments, then double down on the best format.",
      metric: "views, retention, comments, profile visits, website clicks"
    },
    {
      name: "Blog",
      role: "Owned trust + build-in-public",
      status: "Running",
      tone: "running",
      next: "Publish or refresh the “last 10 percent” post when launch signals settle.",
      metric: "traffic, time-on-page, assisted signups"
    },
    {
      name: "Discord",
      role: "UGC + Hall of Fame",
      status: "Next",
      tone: "next",
      next: "Create #hall-of-fame after first players/artifacts appear.",
      metric: "shared stories, art posts, returning players"
    },
    {
      name: "Product Hunt / Show HN",
      role: "One-day launch spike",
      status: "Parked",
      tone: "parked",
      next: "Do not launch until Reddit + TikTok give cleaner positioning signals.",
      metric: "launch-day visits, signups, comments"
    },
    {
      name: "SEO",
      role: "Slow compounding discovery",
      status: "Parked",
      tone: "parked",
      next: "Save for wave 2: solo D&D and Everweave alternative articles.",
      metric: "organic clicks, ranking, signups"
    }
  ],

  tiktokVideos: [
    {
      name: "Gameplay / interface",
      hook: "I wanted a D&D game I could play alone.",
      views: "pending",
      likes: "pending",
      comments: "pending",
      profileVisits: "pending",
      websiteClicks: "pending",
      signups: "pending",
      note: "Main proof that Divergentum is playable, not just fantasy art."
    },
    {
      name: "Race + portraits",
      hook: "Choose your origin.",
      views: "pending",
      likes: "pending",
      comments: "pending",
      profileVisits: "pending",
      websiteClicks: "pending",
      signups: "pending",
      note: "Tests visual character appeal and choice curiosity."
    },
    {
      name: "Fighter",
      hook: "Choose your first hero.",
      views: "pending",
      likes: "pending",
      comments: "pending",
      profileVisits: "pending",
      websiteClicks: "pending",
      signups: "pending",
      note: "Baseline class fantasy."
    },
    {
      name: "Rogue",
      hook: "Bad decisions in dark rooms.",
      views: "pending",
      likes: "pending",
      comments: "pending",
      profileVisits: "pending",
      websiteClicks: "pending",
      signups: "pending",
      note: "Tests mischief / stealth fantasy."
    },
    {
      name: "Wizard",
      hook: "When the horde arrives, the spellbook opens.",
      views: "pending",
      likes: "pending",
      comments: "pending",
      profileVisits: "pending",
      websiteClicks: "pending",
      signups: "pending",
      note: "Solo mage vs crowd of monsters."
    },
    {
      name: "Druid",
      hook: "The forest always has another answer.",
      views: "pending",
      likes: "pending",
      comments: "pending",
      profileVisits: "pending",
      websiteClicks: "pending",
      signups: "pending",
      note: "Tests nature / wild magic fantasy."
    },
    {
      name: "Paladin",
      hook: "A sword, an oath, and absolutely no chill.",
      views: "pending",
      likes: "pending",
      comments: "pending",
      profileVisits: "pending",
      websiteClicks: "pending",
      signups: "pending",
      note: "Tests heroic oath fantasy with humor."
    }
  ],

  experiments: [
    {
      date: "2026-06-22",
      name: "Reddit DevLog",
      channel: "Reddit",
      hypothesis: "High-intent players convert from an honest dev story.",
      metric: "signups via UTM",
      verdict: "running"
    },
    {
      date: "2026-06-22",
      name: "Per-class POV clips",
      channel: "Short-form video",
      hypothesis: "The visual wow drives organic reach.",
      metric: "views → signups via UTM",
      verdict: "running"
    },
    {
      date: "2026-06-22",
      name: "Last 10% blog post",
      channel: "Blog",
      hypothesis: "Build-in-public earns trust and SEO.",
      metric: "traffic, time-on-page",
      verdict: "running"
    },
    {
      date: "2026-06-24",
      name: "Five-class choice gallery",
      channel: "r/Divergentum",
      hypothesis: "A low-pressure visual question earns first community comments and reveals class interest.",
      metric: "comments by class + stated reasons",
      verdict: "planned"
    },
    {
      date: "2026-06-27",
      name: "TikTok first launch batch",
      channel: "TikTok",
      hypothesis: "Short visual proof can introduce Divergentum faster than text and reveal which hook earns attention.",
      metric: "views, watch time, comments, profile visits, clicks, signups",
      verdict: "running"
    },
    {
      date: "planned",
      name: "Product Hunt + Show HN",
      channel: "PH / HN",
      hypothesis: "One-day spike creates IT/angel visibility.",
      metric: "launch-day signups",
      verdict: "parked"
    }
  ],

  nextActions: [
    {
      label: "24h TikTok snapshot",
      detail: "Record views, likes, comments, profile visits, and any website clicks for all seven videos.",
      status: "next"
    },
    {
      label: "Reply to comments",
      detail: "Use comments to clarify that Divergentum is a playable solo D&D-inspired RPG.",
      status: "running"
    },
    {
      label: "Unlock website link",
      detail: "When TikTok opens the Website field, add the profile UTM link.",
      status: "watch"
    },
    {
      label: "Pick the winner",
      detail: "After 72h, make three more videos in the strongest format.",
      status: "next"
    },
    {
      label: "Keep Reddit warm",
      detail: "Do not spam new posts. Answer, comment, and prepare one unique external DevLog.",
      status: "running"
    }
  ],

  dontDoYet: [
    "Product Hunt / Show HN",
    "Paid ads",
    "New channels",
    "Full SEO sprint",
    "Planner v2 or new agent tooling",
    "Deleting and re-uploading TikToks without a real mistake"
  ],

  ga4: {
    recommendedEvents: [
      "sign_up",
      "login",
      "purchase",
      "turn_taken",
      "session_5_turns",
      "campaign_started",
      "character_created"
    ],
    keyEvents: ["sign_up", "session_5_turns", "purchase"],
    checklist: [
      { item: "Confirm GA4 tag is installed on divergentum.com", done: "partial" },
      { item: "Mark sign_up as a key event", done: "pending" },
      { item: "Track turn_taken as a custom event", done: "pending" },
      { item: "Create session_5_turns / activation event", done: "pending" },
      { item: "Mark purchase as a key event when payment path is live", done: "pending" },
      { item: "Use lowercase consistent UTM naming", done: "running" },
      { item: "Check Realtime / DebugView after each event change", done: "pending" }
    ]
  },

  dataViz: {
    tiktokBatch: {
      uploaded: 7,
      metricsCaptured: 0,
      totalMetrics: 7,
      note: "Metrics are intentionally empty until the 24h / 48h / 72h snapshots are recorded."
    },
    updatePipeline: [
      { label: "Manual update file", status: "now", tone: "live" },
      { label: "Validated upload", status: "next", tone: "next" },
      { label: "GA4 connector", status: "later", tone: "watch" },
      { label: "Social APIs", status: "later", tone: "parked" }
    ]
  },

  links: [
    {
      label: "Divergentum website",
      value: "https://www.divergentum.com/"
    },
    {
      label: "TikTok profile UTM",
      value:
        "https://www.divergentum.com/?utm_source=tiktok&utm_medium=social&utm_campaign=profile"
    },
    {
      label: "Reddit community concept",
      value: "r/Divergentum foundation + selective external DevLogs"
    },
    {
      label: "Campaign UTM convention",
      value:
        "utm_source=<channel>&utm_medium=<social|community|owned>&utm_campaign=divergentum_launch_june_2026&utm_content=<asset>"
    }
  ]
};
