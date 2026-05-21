-- =====================================================
-- MailSorter — Nederlandse Editie v1.0
-- Automatische mailsortering voor Apple Mail op macOS
-- github.com/thijsclaassen2002-dotcom/mailsorter
-- =====================================================
--
-- HOE HET WERKT:
--   Laag 1 — Inbox (elke 5 minuten):
--     • Bekende afzender, auto-sort (vlag 0): direct naar Archive, geen vlag.
--     • Bekende afzender, belangrijk (vlag 1–6): krijgt een kleurvlag, blijft in inbox.
--       Druk je op Archiveer, dan sorteert Laag 2 de mail naar de juiste submap.
--     • Onbekende afzender met bijlage of factuurkeyword: rode vlag (actie nodig).
--   Laag 2 — Archive root: alles wat je handmatig archiveert gaat naar de juiste submap.
--   Vlaggen blijven op gearchiveerde mail staan — je ziet altijd de categorie.
--
-- VLAGKLEUREN = CATEGORIE (niet urgentie):
--   0 = geen vlag    (auto-sort — nieuwsbrieven, bezorging)
--   1 = rood         (actie vereist — onbekende afzender met bijlage/factuur)
--   2 = oranje       (financieel)
--   3 = geel         (zakelijk / juridisch)
--   4 = groen        (werk)
--   5 = blauw        (wonen / vastgoed)
--   6 = paars        (gezondheid & overheid)
--
-- INSTELLEN:
--   1. Pas de CONFIGURATIE hieronder aan op jouw situatie.
--   2. Voeg je eigen bank, werkgever en dokter toe (zoek op "JOUW").
--   3. Open Script Editor → Run om te testen.
--   4. Installeer als launchd-agent (zie README.md) voor automatisch uitvoeren.
--
-- REGELFORMAAT: {"@domein-fragment", vlagkleur, "Archive/Mapnaam"}
--   • domein-fragment: deel van het e-mailadres, hoofdletterongevoelig.
--   • vlagkleur 0 = direct archiveren, geen vlag.
--   • vlagkleur 1–6 = kleur toewijzen, in inbox laten; Archiveer → Laag 2 sorteert.
--   • Regels worden van boven naar beneden gecheckt. EERSTE MATCH WINT.
-- =====================================================


-- =====================================================
-- CONFIGURATIE — alleen dit deel aanpassen
-- =====================================================

-- Mappenstructuur onder Archive.
-- Bovenliggende mappen moeten vóór submappen staan.
set archiveFolders to {¬
	"Archive/Financieel", ¬
	"Archive/Financieel/Hypotheek", ¬
	"Archive/Zakelijk", ¬
	"Archive/Werk", ¬
	"Archive/Wonen", ¬
	"Archive/Wonen/Woningzoektocht", ¬
	"Archive/Gezondheid", ¬
	"Archive/Overheid", ¬
	"Archive/Persoonlijk", ¬
	"Archive/LinkedIn", ¬
	"Archive/Bezorging", ¬
	"Archive/Transport", ¬
	"Archive/Nieuwsbrieven", ¬
	"Archive/Nieuwsbrieven/Mode & Shopping", ¬
	"Archive/Nieuwsbrieven/Tech & AI", ¬
	"Archive/Nieuwsbrieven/Evenementen & Uitgaan", ¬
	"Archive/Nieuwsbrieven/Voeding & Sport" ¬
}

-- Onderwerpwoorden die wijzen op een factuur of betaling.
-- Triggert rode vlag voor onbekende afzenders.
set invoiceKeywords to {¬
	"factuur", "rekening", "betaling", "betalingsherinnering", "herinnering", ¬
	"nota", "aanmaning", "incasso", "achterstand", "openstaand", ¬
	"invoice", "payment due", "overdue", "reminder", "statement" ¬
}

-- Persoonlijke e-maildomeinen — onbekende afzenders hiermee gaan naar Archive/Persoonlijk.
set personalDomains to {¬
	"@gmail.com", "@icloud.com", "@outlook.com", "@hotmail.com", ¬
	"@proton.me", "@yahoo.com", "@me.com", "@live.nl", "@live.com", ¬
	"@ziggo.nl", "@kpnmail.nl", "@hetnet.nl", "@planet.nl", "@casema.nl" ¬
}

-- ── AFZENDERREGELS ────────────────────────────────────────────────────────────
-- Formaat: {"@domein-fragment", vlagkleur, "Archive/Doelmap"}
-- Tip: specificiekere domeinen eerst zetten voorkomt fout-positieven.
-- ─────────────────────────────────────────────────────────────────────────────
set senderRules to {¬

	-- ══════════════════════════════════════════════════════════════
	-- AUTO-SORT (vlag = 0): direct naar archive, geen vlag nodig
	-- ══════════════════════════════════════════════════════════════

	-- ── LinkedIn ─────────────────────────────────────────────────
	{"@linkedin.com",                       0, "Archive/LinkedIn"}, ¬
	{"@lnkd.in",                            0, "Archive/LinkedIn"}, ¬
	{"@e.linkedin.com",                     0, "Archive/LinkedIn"}, ¬

	-- ── Bezorging ─────────────────────────────────────────────────
	{"@edm.postnl.nl",                      0, "Archive/Bezorging"}, ¬
	{"@postnl.nl",                          0, "Archive/Bezorging"}, ¬
	{"@dhl.com",                            0, "Archive/Bezorging"}, ¬
	{"@dpd.nl",                             0, "Archive/Bezorging"}, ¬
	{"@gls-group.eu",                       0, "Archive/Bezorging"}, ¬
	{"@gls.nl",                             0, "Archive/Bezorging"}, ¬
	{"@ups.com",                            0, "Archive/Bezorging"}, ¬
	{"@fedex.com",                          0, "Archive/Bezorging"}, ¬
	{"@bpost.be",                           0, "Archive/Bezorging"}, ¬
	{"@budbee.com",                         0, "Archive/Bezorging"}, ¬
	{"@goflink.com",                        0, "Archive/Bezorging"}, ¬
	{"@amazon.nl",                          0, "Archive/Bezorging"}, ¬
	{"@amazon.com",                         0, "Archive/Bezorging"}, ¬
	{"@bol.com",                            0, "Archive/Bezorging"}, ¬

	-- ── Mode & Shopping ───────────────────────────────────────────
	{"@lounge.zalando.nl",                  0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@zalando.nl",                         0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@aboutyou.nl",                        0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@wehkamp.nl",                         0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@hm.com",                             0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@zara.com",                           0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@hema.nl",                            0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@mail.kruidvat.nl",                   0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@kruidvat.nl",                        0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@etos.nl",                            0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@c.rituals.com",                      0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@rituals.com",                        0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@uniqlo.eu",                          0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@store.uniqlo.com",                   0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@eu.temuemail.com",                   0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@dbrand.com",                         0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@travelbags.nl",                      0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@email.karwei.nl",                    0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@shopifyemail.com",                   0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@coolblue.nl",                        0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@mediamarkt.nl",                      0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@action.com",                         0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@decathlon.nl",                       0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬
	{"@ikea.com",                           0, "Archive/Nieuwsbrieven/Mode & Shopping"}, ¬

	-- ── Tech & AI ─────────────────────────────────────────────────
	{"@github.com",                         0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@info.vercel.com",                    0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@vercel.com",                         0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@supabase.com",                       0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@tm.openai.com",                      0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@openai.com",                         0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@mail.anthropic.com",                 0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@email.claude.com",                   0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@anthropic.com",                      0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@windsurf.ai",                        0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@cognition.ai",                       0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@resend.com",                         0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@resend.dev",                         0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@suno.com",                           0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@creators.suno.com",                  0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@news.edx.org",                       0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@formspree.io",                       0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@transip.nl",                         0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬ -- hosting
	{"@hostnet.nl",                         0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@mijndomein.nl",                      0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@cloudflare.com",                     0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@netlify.com",                        0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬
	{"@digitalocean.com",                   0, "Archive/Nieuwsbrieven/Tech & AI"}, ¬

	-- ── Evenementen & Uitgaan ─────────────────────────────────────
	{"@ticketswap.com",                     0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@paylogic.com",                       0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@weeztix.com",                        0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@ticketmaster.nl",                    0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@dice.fm",                            0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@eventbrite.nl",                      0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@eventbrite.com",                     0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@gstpln.com",                         0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@driftomtedansen.nl",                 0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@luxorlive.nl",                       0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@subcultuur.nl",                      0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@parasolevents.nl",                   0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@zorbastreetfood.nl",                 0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬
	{"@jameshoreca.nl",                     0, "Archive/Nieuwsbrieven/Evenementen & Uitgaan"}, ¬

	-- ── Voeding & Sport ───────────────────────────────────────────
	{"@toogoodtogo.nl",                     0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@mail.toogoodtogo.nl",                0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@update.thuisbezorgd.nl",             0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@connect.thuisbezorgd.nl",            0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@ubereats.com",                       0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@uber.com",                           0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@picnic.app",                         0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@hellofresh.nl",                      0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@marleyspoon.nl",                     0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@update.strava.com",                  0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@strava.com",                         0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@mail.beehiiv.com",                   0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@beehiiv.com",                        0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@houseofsports.nl",                   0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬
	{"@decathlon.nl",                       0, "Archive/Nieuwsbrieven/Voeding & Sport"}, ¬

	-- ── Transport ────────────────────────────────────────────────
	{"@email.ns.nl",                        0, "Archive/Transport"}, ¬
	{"@ns.nl",                              0, "Archive/Transport"}, ¬
	{"@ov-chipkaart.nl",                    0, "Archive/Transport"}, ¬
	{"@9292.nl",                            0, "Archive/Transport"}, ¬
	{"@connexxion.nl",                      0, "Archive/Transport"}, ¬
	{"@arriva.nl",                          0, "Archive/Transport"}, ¬
	{"@qbuzz.nl",                           0, "Archive/Transport"}, ¬
	{"@ret.nl",                             0, "Archive/Transport"}, ¬
	{"@gvb.nl",                             0, "Archive/Transport"}, ¬
	{"@htm.nl",                             0, "Archive/Transport"}, ¬
	{"@anwb.nl",                            0, "Archive/Transport"}, ¬
	{"@e.kwikfit.nl",                       0, "Archive/Transport"}, ¬
	{"@discover.airbnb.com",                0, "Archive/Transport"}, ¬
	{"@airbnb.com",                         0, "Archive/Transport"}, ¬
	{"@easyjet.com",                        0, "Archive/Transport"}, ¬
	{"@ryanair.com",                        0, "Archive/Transport"}, ¬
	{"@klm.com",                            0, "Archive/Transport"}, ¬
	{"@transavia.com",                      0, "Archive/Transport"}, ¬
	{"@eurostar.com",                       0, "Archive/Transport"}, ¬
	{"@flixbus.com",                        0, "Archive/Transport"}, ¬
	{"@thalys.com",                         0, "Archive/Transport"}, ¬

	-- ── Overige nieuwsbrieven ─────────────────────────────────────
	{"@vriendenloterij.nl",                 0, "Archive/Nieuwsbrieven"}, ¬
	{"@postcodeloterij.nl",                 0, "Archive/Nieuwsbrieven"}, ¬
	{"@opens.socialdeal.nl",                0, "Archive/Nieuwsbrieven"}, ¬
	{"@socialdeal.nl",                      0, "Archive/Nieuwsbrieven"}, ¬
	{"@swipe4work.com",                     0, "Archive/Nieuwsbrieven"}, ¬
	{"@e.kika.nl",                          0, "Archive/Nieuwsbrieven"}, ¬
	{"@degoedezaak.org",                    0, "Archive/Nieuwsbrieven"}, ¬
	{"@info.hbomax.com",                    0, "Archive/Nieuwsbrieven"}, ¬
	{"@netflix.com",                        0, "Archive/Nieuwsbrieven"}, ¬
	{"@spotify.com",                        0, "Archive/Nieuwsbrieven"}, ¬
	{"@indeedemail.com",                    0, "Archive/Nieuwsbrieven"}, ¬
	{"@nationalevacaturebank.nl",           0, "Archive/Nieuwsbrieven"}, ¬
	{"@werkzoeken.nl",                      0, "Archive/Nieuwsbrieven"}, ¬


	-- ══════════════════════════════════════════════════════════════
	-- BELANGRIJK (vlag 2–6): blijft in inbox met kleurvlag
	-- ══════════════════════════════════════════════════════════════

	-- ── 🟠 ORANJE (2): Financieel ────────────────────────────────
	-- Hypotheek
	{"@notificatie.svn.nl",                 2, "Archive/Financieel/Hypotheek"}, ¬
	{"@svn.nl",                             2, "Archive/Financieel/Hypotheek"}, ¬
	{"@hdn.nl",                             2, "Archive/Financieel/Hypotheek"}, ¬
	-- JOUW hypotheekverstrekker toevoegen: {"@jouwhypotheek.nl", 2, "Archive/Financieel/Hypotheek"},

	-- Nederlandse banken
	{"@ing.com",                            2, "Archive/Financieel"}, ¬
	{"@rabobank.nl",                        2, "Archive/Financieel"}, ¬
	{"@e-mail.rabobank.nl",                 2, "Archive/Financieel"}, ¬
	{"@abnamro.nl",                         2, "Archive/Financieel"}, ¬
	{"@nl.abnamro.com",                     2, "Archive/Financieel"}, ¬
	{"@snsbank.nl",                         2, "Archive/Financieel"}, ¬
	{"@asnbank.nl",                         2, "Archive/Financieel"}, ¬
	{"@regiobank.nl",                       2, "Archive/Financieel"}, ¬
	{"@triodos.nl",                         2, "Archive/Financieel"}, ¬
	{"@bunq.com",                           2, "Archive/Financieel"}, ¬
	{"@knab.nl",                            2, "Archive/Financieel"}, ¬
	{"@n26.com",                            2, "Archive/Financieel"}, ¬
	{"@revolut.com",                        2, "Archive/Financieel"}, ¬
	{"@wise.com",                           2, "Archive/Financieel"}, ¬
	-- JOUW bank toevoegen als die er niet bij staat: {"@jouwebank.nl", 2, "Archive/Financieel"},

	-- Betaaldiensten
	{"@communications.paypal.com",          2, "Archive/Financieel"}, ¬
	{"@paypal.com",                         2, "Archive/Financieel"}, ¬
	{"@klarna.nl",                          2, "Archive/Financieel"}, ¬
	{"@klarna.com",                         2, "Archive/Financieel"}, ¬
	{"@mollie.com",                         2, "Archive/Financieel"}, ¬
	{"@notification.mollie.com",            2, "Archive/Financieel"}, ¬
	{"@tikkie.me",                          2, "Archive/Financieel"}, ¬

	-- Belasting & toeslagen
	{"@belastingdienst.nl",                 2, "Archive/Financieel"}, ¬
	{"@toeslagen.nl",                       2, "Archive/Financieel"}, ¬

	-- Verzekeringen
	{"@vgz.nl",                             2, "Archive/Financieel"}, ¬
	{"@menzis.nl",                          2, "Archive/Financieel"}, ¬
	{"@cz.nl",                              2, "Archive/Financieel"}, ¬
	{"@zilverenkruis.nl",                   2, "Archive/Financieel"}, ¬
	{"@dsw.nl",                             2, "Archive/Financieel"}, ¬
	{"@onvz.nl",                            2, "Archive/Financieel"}, ¬
	{"@centraal-beheer.nl",                 2, "Archive/Financieel"}, ¬
	{"@nn.nl",                              2, "Archive/Financieel"}, ¬ -- Nationale Nederlanden
	{"@aegon.nl",                           2, "Archive/Financieel"}, ¬
	{"@asr.nl",                             2, "Archive/Financieel"}, ¬
	{"@ingoedehanden.nl",                   2, "Archive/Financieel"}, ¬
	-- JOUW zorgverzekeraar toevoegen als die er niet bij staat

	-- Telecom rekeningen
	{"@vodafone.nl",                        2, "Archive/Financieel"}, ¬
	{"@odido.nl",                           2, "Archive/Financieel"}, ¬
	{"@kpn.com",                            2, "Archive/Financieel"}, ¬
	{"@ziggo.nl",                           2, "Archive/Financieel"}, ¬
	{"@tele2.nl",                           2, "Archive/Financieel"}, ¬
	{"@simpel.nl",                          2, "Archive/Financieel"}, ¬
	{"@youfone.nl",                         2, "Archive/Financieel"}, ¬

	-- Energie rekeningen
	{"@vattenfall.nl",                      2, "Archive/Financieel"}, ¬
	{"@eneco.nl",                           2, "Archive/Financieel"}, ¬
	{"@essent.nl",                          2, "Archive/Financieel"}, ¬
	{"@greenchoice.nl",                     2, "Archive/Financieel"}, ¬
	{"@oxxio.nl",                           2, "Archive/Financieel"}, ¬
	{"@tibber.com",                         2, "Archive/Financieel"}, ¬

	-- Incasso & deurwaarders
	{"@flanderijn.nl",                      2, "Archive/Financieel"}, ¬
	{"@intrum.nl",                          2, "Archive/Financieel"}, ¬
	{"@cjib.nl",                            2, "Archive/Financieel"}, ¬ -- verkeersboetes
	{"@tkb.nl",                             2, "Archive/Financieel"}, ¬
	{"@infomedics.nl",                      2, "Archive/Financieel"}, ¬ -- medische facturen

	-- ── 🟡 GEEL (3): Zakelijk / Juridisch ────────────────────────
	{"@kvk.nl",                             3, "Archive/Zakelijk"}, ¬
	{"@docusign.net",                       3, "Archive/Zakelijk"}, ¬
	{"@eumail.docusign.net",                3, "Archive/Zakelijk"}, ¬
	{"@docusign.com",                       3, "Archive/Zakelijk"}, ¬
	{"@signhost.com",                       3, "Archive/Zakelijk"}, ¬
	{"@hellosign.com",                      3, "Archive/Zakelijk"}, ¬
	{"@sign.plus",                          3, "Archive/Zakelijk"}, ¬
	{"@exact.com",                          3, "Archive/Zakelijk"}, ¬ -- Exact Online
	{"@moneybird.com",                      3, "Archive/Zakelijk"}, ¬
	{"@twinfield.com",                      3, "Archive/Zakelijk"}, ¬
	{"@yuki.nl",                            3, "Archive/Zakelijk"}, ¬
	-- JOUW advocaat / notaris / accountant toevoegen:
	-- {"@jouwadvocaat.nl", 3, "Archive/Zakelijk"},

	-- ── 🟢 GROEN (4): Werk ───────────────────────────────────────
	-- JOUW werkgever(s) hier toevoegen:
	-- {"@jouwwerkgever.nl",                4, "Archive/Werk"},
	-- {"@jouwklant.nl",                    4, "Archive/Werk"},
	{"@info.werkspot.nl",                   4, "Archive/Werk"}, ¬ -- klantvragen via Werkspot
	{"@tempo-team.nl",                      4, "Archive/Werk"}, ¬
	{"@randstad.nl",                        4, "Archive/Werk"}, ¬
	{"@adecco.nl",                          4, "Archive/Werk"}, ¬
	{"@manpower.nl",                        4, "Archive/Werk"}, ¬

	-- ── 🔵 BLAUW (5): Wonen ──────────────────────────────────────
	{"@email.funda.nl",                     5, "Archive/Wonen/Woningzoektocht"}, ¬
	{"@funda.nl",                           5, "Archive/Wonen/Woningzoektocht"}, ¬
	{"@pararius.nl",                        5, "Archive/Wonen/Woningzoektocht"}, ¬
	{"@huurwoningen.nl",                    5, "Archive/Wonen/Woningzoektocht"}, ¬
	{"@kamernet.nl",                        5, "Archive/Wonen/Woningzoektocht"}, ¬
	{"@woningnet.nl",                       5, "Archive/Wonen/Woningzoektocht"}, ¬
	{"@woonnet.nl",                         5, "Archive/Wonen/Woningzoektocht"}, ¬
	{"@makelaarsland.nl",                   5, "Archive/Wonen"}, ¬
	{"@move.nl",                            5, "Archive/Wonen"}, ¬
	{"@nederwoon.nl",                       5, "Archive/Wonen"}, ¬
	{"@eerlijkbieden.nl",                   5, "Archive/Wonen"}, ¬
	{"@jouwmakelaar.online",                5, "Archive/Wonen"}, ¬
	{"@nvm.nl",                             5, "Archive/Wonen"}, ¬
	{"@dingdong",                           5, "Archive/Wonen"}, ¬ -- VvE-beheer
	-- JOUW makelaar toevoegen:
	-- {"@jouwijkmakelaar.nl",              5, "Archive/Wonen"},

	-- ── 🟣 PAARS (6): Gezondheid ─────────────────────────────────
	{"@radboudumc.nl",                      6, "Archive/Gezondheid"}, ¬
	{"@amsterdamumc.nl",                    6, "Archive/Gezondheid"}, ¬
	{"@erasmusmc.nl",                       6, "Archive/Gezondheid"}, ¬
	{"@umcutrecht.nl",                      6, "Archive/Gezondheid"}, ¬
	{"@lumc.nl",                            6, "Archive/Gezondheid"}, ¬
	{"@umcg.nl",                            6, "Archive/Gezondheid"}, ¬
	{"@maastrichtuniversityhospital.nl",    6, "Archive/Gezondheid"}, ¬
	{"@zorgdomein.nl",                      6, "Archive/Gezondheid"}, ¬ -- verwijzingen
	{"@buurtzorgt.nl",                      6, "Archive/Gezondheid"}, ¬
	{"@buurtteamsvolwassenen.nl",           6, "Archive/Gezondheid"}, ¬
	{"@ggd.nl",                             6, "Archive/Gezondheid"}, ¬
	{"@ggz.nl",                             6, "Archive/Gezondheid"}, ¬
	-- JOUW huisarts / tandarts / specialist toevoegen:
	-- {"@jouwtandarts.nl",                 6, "Archive/Gezondheid"},

	-- ── 🟣 PAARS (6): Overheid ────────────────────────────────────
	{"@digid.nl",                           6, "Archive/Overheid"}, ¬
	{"@rijksoverheid.nl",                   6, "Archive/Overheid"}, ¬
	{"@rdw.nl",                             6, "Archive/Overheid"}, ¬ -- kenteken/rijbewijs
	{"@duo.nl",                             6, "Archive/Overheid"}, ¬ -- studielening
	{"@uwv.nl",                             6, "Archive/Overheid"}, ¬ -- uitkering / WW
	{"@svb.nl",                             6, "Archive/Overheid"}, ¬ -- AOW / kinderbijslag
	{"@hetcak.nl",                          6, "Archive/Overheid"}, ¬ -- eigen bijdrage zorg
	{"@ciz.nl",                             6, "Archive/Overheid"}, ¬ -- WLZ indicatie
	{"@rechtspraak.nl",                     6, "Archive/Overheid"}, ¬
	{"@cbs.nl",                             6, "Archive/Overheid"}, ¬
	-- Gemeentes: voeg jouw gemeente toe:
	-- {"@amsterdam.nl",                    6, "Archive/Overheid"},
	-- {"@rotterdam.nl",                    6, "Archive/Overheid"},
	-- {"@denhaag.nl",                      6, "Archive/Overheid"},
	-- {"@utrecht.nl",                      6, "Archive/Overheid"},
	-- {"@nijmegen.nl",                     6, "Archive/Overheid"},
	{"@nijmegen.nl",                        6, "Archive/Overheid"}, ¬
	{"@overbetuwe.nl",                      6, "Archive/Overheid"}, ¬
	{"@dar.nl",                             6, "Archive/Overheid"}, ¬ -- afval
	{"@rsc.ru.nl",                          6, "Archive/Overheid"} ¬

}

-- =====================================================
-- ENGINE — niet aanpassen
-- =====================================================

tell application "Mail"
	with timeout of 300 seconds

	-- iCloud-account zoeken (of eerste account als fallback)
	set icloudAccount to missing value
	repeat with anAccount in accounts
		try
			repeat with anEmail in (email addresses of anAccount)
				if (anEmail as string) contains "icloud.com" or (anEmail as string) contains "me.com" or (anEmail as string) contains "mac.com" then
					set icloudAccount to anAccount
					exit repeat
				end if
			end repeat
		end try
		if icloudAccount is not missing value then exit repeat
	end repeat
	if icloudAccount is missing value then set icloudAccount to item 1 of accounts

	-- Ontbrekende mappen aanmaken
	repeat with fn in archiveFolders
		try
			set x to mailbox (fn as string) of icloudAccount
		on error
			make new mailbox with properties {name:(fn as string)} at icloudAccount
		end try
	end repeat

	set autoCount to 0
	set flagCount to 0
	set archiveCount to 0

	-- ── LAAG 1: Inbox verwerken ───────────────────────────────────
	set inboxMsgs to messages of inbox
	repeat with aMsg in inboxMsgs
		try
			set sndr to sender of aMsg
			set subj to subject of aMsg
			set hasAttachment to (count of mail attachments of aMsg) > 0

			-- Onderwerpcheck op factuurkeywords
			set isInvoice to false
			repeat with kw in invoiceKeywords
				if subj contains (kw as string) then
					set isInvoice to true
					exit repeat
				end if
			end repeat

			-- Match afzender tegen regels (eerste match wint)
			set matchedFlag to -1
			set matchedFolder to ""
			repeat with rule in senderRules
				if sndr contains (item 1 of rule as string) then
					set matchedFlag to item 2 of rule
					set matchedFolder to item 3 of rule
					exit repeat
				end if
			end repeat

			if matchedFlag is 0 then
				-- Auto-sort: direct naar archive, geen vlag
				move aMsg to mailbox matchedFolder of icloudAccount
				set autoCount to autoCount + 1
			else if matchedFlag > 0 then
				-- Bekende afzender: kleurvlag, blijft in inbox
				set flag index of aMsg to matchedFlag
				set flagCount to flagCount + 1
			else
				-- Onbekende afzender: rode vlag alleen bij actie nodig
				if hasAttachment or isInvoice then
					set flag index of aMsg to 1
					set flagCount to flagCount + 1
				end if
			end if
		on error
		end try
	end repeat

	-- ── LAAG 2: Archive root → juiste submap (vlag blijft) ────────
	try
		set archiveMb to mailbox "Archive" of icloudAccount
		set archivedMsgs to messages of archiveMb
		repeat with aMsg in archivedMsgs
			try
				set sndr to sender of aMsg
				set matchedFolder to ""

				-- Match tegen afzenderregels
				repeat with rule in senderRules
					if sndr contains (item 1 of rule as string) then
						set matchedFolder to item 3 of rule
						exit repeat
					end if
				end repeat

				-- Fallback: persoonlijke domeinen → Archive/Persoonlijk
				if matchedFolder is "" then
					repeat with pd in personalDomains
						if sndr contains (pd as string) then
							set matchedFolder to "Archive/Persoonlijk"
							exit repeat
						end if
					end repeat
				end if

				if matchedFolder is not "" then
					move aMsg to mailbox matchedFolder of icloudAccount
					set archiveCount to archiveCount + 1
				end if
			on error
			end try
		end repeat
	on error
	end try

	-- Notificatie tonen als er iets gesorteerd is
	if autoCount > 0 or archiveCount > 0 then
		set msg to ""
		if autoCount > 0 then set msg to msg & autoCount & " auto"
		if autoCount > 0 and archiveCount > 0 then set msg to msg & " · "
		if archiveCount > 0 then set msg to msg & archiveCount & " gearchiveerd"
		display notification msg with title "MailSorter NL"
	end if

	end timeout
end tell
