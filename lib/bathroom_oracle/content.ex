defmodule BathroomOracle.Content do
  @moduledoc false

  alias BathroomOracle.{Question, Verdict}

  @spec header_line(non_neg_integer()) :: String.t()
  def header_line(seed) do
    pick(
      [
        "The Bathroom Oracle has considered your request.",
        "The tiles received your question.",
        "The council convened in damp silence.",
        "Steam gathered. Judgment followed.",
        "The chamber listened with unreasonable seriousness.",
        "The grout accepted your petition.",
        "A hush fell over the fixtures.",
        "The porcelain authorities have reached the unpleasant part.",
        "The room took notes in condensation.",
        "The plumbing observed everything and hated most of it."
      ],
      seed
    )
  end

  @spec entity_name(atom()) :: String.t()
  def entity_name(:mirror_of_doubt), do: "Mirror of Doubt"
  def entity_name(:sink_of_mercury), do: "Sink of Mercury"
  def entity_name(:third_towel), do: "Third Towel"
  def entity_name(:soap_of_clarity), do: "Soap of Clarity"

  @spec vote_label(atom()) :: String.t()
  def vote_label(:yes), do: "Yes"
  def vote_label(:no), do: "No"
  def vote_label(:abstain), do: "Abstain"

  @spec entity_reason(atom(), atom(), non_neg_integer()) :: String.t()
  def entity_reason(entity, reason_key, seed) do
    entity
    |> entity_reason_bank()
    |> Map.fetch!(reason_key)
    |> pick(seed)
  end

  @spec omen_label(atom()) :: String.t()
  def omen_label(:steam_density), do: "Steam density"
  def omen_label(:tile_resonance), do: "Tile resonance"
  def omen_label(:mirror_clarity), do: "Mirror clarity"
  def omen_label(:towel_alignment), do: "Towel alignment"

  @spec omen_value(atom(), atom(), non_neg_integer()) :: String.t()
  def omen_value(:steam_density, :favorable, seed) do
    pick(["favorable", "favorable, with restraint", "favorable enough"], seed)
  end

  def omen_value(:steam_density, :neutral, seed) do
    pick(["neutral", "neutral and unimpressed", "neutral, bordering on bored"], seed)
  end

  def omen_value(:steam_density, :ominous, seed) do
    pick(["ominous", "ominous and clinging", "ominous in a very damp way"], seed)
  end

  def omen_value(:tile_resonance, :steady, seed) do
    pick(["steady", "steady for now", "steady under inspection"], seed)
  end

  def omen_value(:tile_resonance, :wavering, seed) do
    pick(["wavering", "wavering but salvageable", "wavering in a suspicious rhythm"], seed)
  end

  def omen_value(:tile_resonance, :unstable, seed) do
    pick(["unstable", "unstable and echoing", "unstable in a legally concerning way"], seed)
  end

  def omen_value(:mirror_clarity, :clear, seed) do
    pick(["clear", "clear enough for consequences", "clear and annoyingly direct"], seed)
  end

  def omen_value(:mirror_clarity, :clouded, seed) do
    pick(["clouded", "clouded around the edges", "clouded with preventable fog"], seed)
  end

  def omen_value(:mirror_clarity, :smudged, seed) do
    pick(["smudged", "smudged beyond diplomacy", "smudged and morally busy"], seed)
  end

  def omen_value(:towel_alignment, :aligned, seed) do
    pick(["aligned", "aligned with purpose", "aligned to an almost suspicious degree"], seed)
  end

  def omen_value(:towel_alignment, :slack, seed) do
    pick(["slack", "slack but recoverable", "slack in spirit"], seed)
  end

  def omen_value(:towel_alignment, :crooked, seed) do
    pick(["crooked", "crooked with intent", "crooked and not apologizing"], seed)
  end

  @spec interpretation(Question.t(), Verdict.t(), non_neg_integer()) :: String.t()
  def interpretation(%Question{} = question, %Verdict{} = verdict, seed) do
    specific = %{
      {:ambition, :proceed_carefully, :uncertain} => [
        "Your desire is real, but your timing leaks.",
        "The ambition is sound. The dramatic flourish is not yet load-bearing.",
        "The room supports movement, not theatrical lunging."
      ],
      {:ambition, :yes, :sincere} => [
        "The room sees movement here, provided you stop narrating and start acting.",
        "This can proceed if you replace mystique with one competent next step."
      ],
      {:ambition, :no, :arrogant} => [
        "The goal may survive. Your current posture will not help it.",
        "Ambition arrived overdressed and underprepared."
      ],
      {:romance, :no, :desperate} => [
        "This question seeks permission, not truth.",
        "Romance was not harmed here; dignity might be.",
        "The feeling is genuine. The timing is pleading.",
        "The chamber suspects you want relief more than clarity."
      ],
      {:romance, :proceed_carefully, :uncertain} => [
        "The feeling is real. The phrasing arrived underdressed.",
        "There is a heart in this question, but it is standing too close to the panic."
      ],
      {:romance, :ask_later, :uncertain} => [
        "Not every ache deserves immediate dispatch.",
        "The sentiment can wait. Your thumbs will survive."
      ],
      {:appearance, :no, :arrogant} => [
        "Confidence is present, but it has not checked the lighting.",
        "You are asking the mirror to applaud before the experiment has happened."
      ],
      {:appearance, :proceed_carefully, :sincere} => [
        "Aesthetic risk is acceptable when panic is not driving it.",
        "This may work if vanity stops grabbing the steering wheel."
      ],
      {:appearance, :yes, :sincere} => [
        "The room does not oppose the transformation. It merely fears your follow-through."
      ],
      {:money, :ask_later, :uncertain} => [
        "The numbers may improve, but this wording will not do it for them.",
        "Financial clarity has not arrived, and vibes will not invoice themselves."
      ],
      {:money, :no, :desperate} => [
        "You are trying to negotiate with panic and call it strategy.",
        "The arithmetic is not cruel. It is simply not flirting with you."
      ],
      {:money, :yes, :sincere} => [
        "This is one of the rarer moments when practicality sounds almost noble."
      ],
      {:impulse, :no, :chaotic} => [
        "The urge is loud because the plan is missing.",
        "Speed has entered the room as a substitute for judgment.",
        "The idea is sprinting because it knows it would lose at walking pace."
      ],
      {:impulse, :proceed_carefully, :uncertain} => [
        "An impulse can mature into a decision, but not in the next thirty seconds."
      ],
      {:general, :oracle_refuses, :chaotic} => [
        "The chamber will not bless whatever this tone is trying to accomplish.",
        "The room rejects both the urgency and the formatting."
      ],
      {:general, :ask_later, :uncertain} => [
        "The question is not hopeless. It is merely damp around the edges.",
        "A usable truth may exist here after one less dramatic draft."
      ]
    }

    fallback_by_verdict = %{
      yes: [
        "The room does not object, though it expects follow-through.",
        "Permission has been granted with visible reluctance.",
        "This is approved, but not in a way that flatters you.",
        "The chamber permits the move and reserves the right to smirk later.",
        "Yes, though the sink would like to note its mild disappointment in your process."
      ],
      proceed_carefully: [
        "The path exists, but it is still slippery.",
        "This may proceed, though not with the confidence currently on display.",
        "The answer is usable, provided you stop treating caution as an insult.",
        "Proceed, but bring less performance and more traction.",
        "The room is not stopping you. It is merely documenting the risk."
      ],
      ask_later: [
        "The answer is not no. The answer is not with this atmosphere.",
        "The chamber requests improved timing and less emotional condensation.",
        "Nothing fatal is happening here except the phrasing.",
        "Time may improve this. More urgency will not.",
        "The room prefers a second draft and a calmer pulse."
      ],
      no: [
        "The sink knows a bad idea when it hears one echo.",
        "Practical reality entered the room and ruined the mood.",
        "The answer is no, and the tiles would like that to be enough.",
        "This fails the bathroom test on both timing and dignity.",
        "The chamber denies the request and declines cross-examination."
      ],
      oracle_refuses: [
        "The Oracle declines to participate in whatever this spiral has become.",
        "The room has standards, however humiliating that may be for everyone involved.",
        "This request arrived in a state the chamber considers unserious.",
        "The fixtures have recused themselves on grounds of emotional misconduct.",
        "The chamber rejects both the premise and the energy."
      ]
    }

    fallback_by_tone = %{
      uncertain: [
        "Your hesitation is louder than your plan.",
        "You are asking softly and wanting loudly.",
        "The uncertainty is understandable. The sentence is still flimsy."
      ],
      desperate: [
        "Urgency has chewed holes in the sentence.",
        "The question arrived clutching the doorframe.",
        "Neediness is not the same thing as evidence."
      ],
      arrogant: [
        "The confidence is impressive. The evidence is not.",
        "Certainty has shown up too early and is already making the room tired.",
        "The tone assumes victory before the towel has even voted."
      ],
      sincere: [
        "There is a decent question under the damp dramatics.",
        "At least the intent here survives inspection.",
        "The room respects honesty even when the timing is ugly."
      ],
      chaotic: [
        "The wording entered the chamber at unsafe speed.",
        "Several punctuation marks are behaving like a public incident.",
        "The sentence needs containment before it needs prophecy."
      ]
    }

    lines =
      Map.get(specific, {question.category, verdict.key, question.tone}) ||
        Map.fetch!(fallback_by_verdict, verdict.key) ++
          Map.fetch!(fallback_by_tone, question.tone)

    pick(lines, seed)
  end

  @spec ritual(Question.t(), Verdict.t(), non_neg_integer()) :: String.t()
  def ritual(%Question{} = question, %Verdict{} = verdict, seed) do
    specific = %{
      {:ambition, :proceed_carefully} => [
        "Fold one clean towel. Wait until :47 past the hour. Then speak your plan out loud once.",
        "Stand up straighter, adjust one practical detail, and ask again only once.",
        "Write down the next boring step. Perform that step before indulging in mystery.",
        "Rinse the performance from the idea and return with a timetable."
      ],
      {:ambition, :yes} => [
        "Open one document, send one message, and do not call it destiny until lunch.",
        "Straighten the sink mat, then begin the practical part immediately."
      ],
      {:romance, :no} => [
        "Wash your hands, do not send the message tonight, and survive until morning.",
        "Leave the phone alone for 19 minutes and return with a better reason than longing.",
        "Place the device face down. Let desire experience one administrative delay.",
        "Drink water, regain posture, and deny the first draft of the confession."
      ],
      {:romance, :proceed_carefully} => [
        "Edit the sentence once, remove one needy word, then decide if it still deserves daylight.",
        "Wait for the next even minute. If the message still seems wise, reduce it by a third."
      ],
      {:appearance, :proceed_carefully} => [
        "Change one thing, not three. The towel insists on restraint.",
        "Try the alteration in proper lighting and ban all panic scissors.",
        "Permit one experiment and one mirror only. No committee of mirrors."
      ],
      {:appearance, :yes} => [
        "Commit cleanly. Hesitant styling has harmed enough people already.",
        "Make the change, then stop asking the room to re-litigate it."
      ],
      {:money, :ask_later} => [
        "Check the numbers, drink water, and bring back a sentence with fewer vibes in it.",
        "Open the account, count honestly, and return once the drama has been itemized.",
        "Do not consult prophecy before consulting arithmetic."
      ],
      {:money, :yes} => [
        "Verify the boring detail, then proceed before hesitation invents a personality.",
        "Count twice, act once, and do not improvise with rent-adjacent matters."
      ],
      {:impulse, :no} => [
        "Sit down for seven minutes and deny the first version of the idea.",
        "Leave the bathroom, keep the idea, discard the velocity.",
        "Delay the impulse until it can survive contact with a calendar."
      ],
      {:impulse, :proceed_carefully} => [
        "Wait one song length. If the idea still breathes, reduce the damage radius.",
        "Give the impulse a smaller budget and a chaperone."
      ]
    }

    fallback = %{
      yes: [
        "Rinse the doubt from your hands and proceed before the mood cools.",
        "Straighten one object in the room, then go do the thing.",
        "Take the nearest practical action and resist the urge to make it symbolic.",
        "Proceed while the chamber is still being uncharacteristically generous."
      ],
      proceed_carefully: [
        "Wait until the next odd minute and repeat the question without begging.",
        "Fold one towel, fix one practical detail, then continue.",
        "Proceed only after removing one dramatic flourish from your plan.",
        "Reduce the chaos, then try again with adult footwear on the sentence."
      ],
      ask_later: [
        "Leave the room, return after a short walk, and ask with cleaner wording.",
        "Pause, breathe, and do not mistake urgency for instruction.",
        "Wait until your pulse stops editing the facts.",
        "Consult time before consulting destiny again."
      ],
      no: [
        "Do not force this. Clean the sink and let the idea embarrass itself.",
        "Step away from the mirror and stop helping the bad idea feel wanted.",
        "Perform one mundane task and allow the fantasy to cool on its own.",
        "The ritual is refusal. Be grateful it is cheaper than regret."
      ],
      oracle_refuses: [
        "The ritual is silence. Leave now and re-enter in a less theatrical state.",
        "The chamber demands water, posture, and a full emotional reset.",
        "Close the loop, lower the drama, and return only after language improves.",
        "No ritual has been granted. That is the ritual."
      ]
    }

    lines =
      Map.get(specific, {question.category, verdict.key}) || Map.fetch!(fallback, verdict.key)

    pick(lines, seed + severity_offset(verdict.severity))
  end

  defp entity_reason_bank(:mirror_of_doubt) do
    %{
      false_certainty: [
        "Confidence entered before evidence.",
        "The mirror dislikes certainty that has not suffered even once.",
        "The room noticed swagger arriving without paperwork."
      ],
      fear_detected: [
        "The mirror heard fear asking for a costume.",
        "Fear has powdered its nose and called itself instinct.",
        "The mirror identified panic wearing formal shoes."
      ],
      vanity_detected: [
        "Vanity fogged the glass before truth arrived.",
        "The mirror observed ambition, but mostly for applause.",
        "Image entered first and meaning got stuck in the hallway."
      ],
      honest_intent: [
        "At least one face in the room is being honest.",
        "The mirror dislikes this, which usually means the intent is genuine.",
        "Something truthful survived the self-consciousness."
      ],
      nothing_to_mock: [
        "The mirror found nothing deliciously weak.",
        "For once, the reflection did not arrive asking for pity.",
        "The mirror searched for rot and came back underemployed."
      ],
      weak_intent: [
        "The request arrived wearing unsure shoes.",
        "Intent is present, but it refuses to stand up straight.",
        "The mirror suspects you want absolution more than direction."
      ]
    }
  end

  defp entity_reason_bank(:sink_of_mercury) do
    %{
      wet_brakes: [
        "Momentum exists, but traction does not.",
        "The sink reports acceleration without steering.",
        "The plumbing has seen this kind of skid before."
      ],
      bad_timing: [
        "Timing dripped straight through the basin.",
        "The sink rejects the schedule on practical grounds.",
        "Whatever this is, it would improve by not being today."
      ],
      momentum_favorable: [
        "Practical current is finally moving your way.",
        "The basin rarely says yes, which should worry and encourage you equally.",
        "Conditions are competent enough to permit action."
      ],
      practical_current: [
        "The sink respects a clean, workable plan.",
        "There is enough structure here to keep the room calm.",
        "The plumbing favors boring competence over shiny collapse."
      ],
      drainage_inconclusive: [
        "The plumbing declined to elaborate.",
        "The drain muttered something useless and retreated.",
        "No practical signal emerged from the basin."
      ]
    }
  end

  defp entity_reason_bank(:third_towel) do
    %{
      wrung_out: [
        "The towel refuses to endorse a soggy impulse.",
        "The fabric has absorbed enough nonsense already.",
        "The towel will not co-sign emotional moisture."
      ],
      proper_fold: [
        "Discipline, while unfashionable, remains persuasive.",
        "The towel approves of structure when nobody else will.",
        "A decent fold can still save a weak atmosphere."
      ],
      presentation_matters: [
        "Presentation is not nothing, unfortunately.",
        "The towel is shallow in a strangely reliable way.",
        "Order of appearance still counts for something in this room."
      ],
      hanging_back: [
        "The towel hangs in silence and reserves judgment.",
        "The third towel remains neutral out of ancestral fatigue.",
        "No useful textile opinion could be extracted."
      ]
    }
  end

  defp entity_reason_bank(:soap_of_clarity) do
    %{
      lather_rejected: [
        "Clarity does not negotiate with chaos.",
        "The soap slid off this sentence in self-defense.",
        "No amount of lather could rescue that energy."
      ],
      murky_phrasing: [
        "The sentence arrived with residue on it.",
        "The soap found the wording cloudy and slightly sticky.",
        "Clarity requested a rinse and received a monologue."
      ],
      clean_intent: [
        "Intent rinsed clean enough to proceed.",
        "The soap respects motive that survives water pressure.",
        "Clarity emerged with minimal scrubbing."
      ],
      no_lather: [
        "The soap found nothing to grip.",
        "There was too little substance here to clean.",
        "The lather formed, then gave up on the premise."
      ],
      clarity_emerges: [
        "A usable truth appeared after one rinse.",
        "The soap located something workable under the mess.",
        "Clarity surfaced, though not elegantly."
      ]
    }
  end

  defp severity_offset(:low), do: 1
  defp severity_offset(:medium), do: 3
  defp severity_offset(:high), do: 5

  defp pick(lines, seed) do
    Enum.at(lines, rem(abs(seed), length(lines)))
  end
end
