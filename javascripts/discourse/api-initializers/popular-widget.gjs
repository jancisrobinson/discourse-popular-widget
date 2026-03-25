import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { apiInitializer } from "discourse/lib/api";
import Topic from "discourse/models/topic";
import LatestTopicListItem from "discourse/components/topic-list/latest-topic-list-item";

export default apiInitializer("1.0.0", (api) => {
  api.renderInOutlet("above-discovery-categories", class PopularTopicsWidget extends Component {
    @tracked topics = [];
    @tracked loading = true;

    constructor() {
      super(...arguments);
      if (this.shouldShow) {
        this.fetchTopics();
      }
    }

    get shouldShow() {
      return settings.show_on_home;
    }

    async fetchTopics() {
      try {
        const result = await ajax(`/top.json?period=${settings.period}`);
        const users = {};
        (result.users || []).forEach((u) => (users[u.id] = u));

        const rawTopics = (result.topic_list?.topics || []).slice(
          0,
          settings.topic_count
        );

        this.topics = rawTopics.map((t) =>
          Topic.create({
            ...t,
            posters: (t.posters || []).map((p) => ({
              ...p,
              user: users[p.user_id],
            })),
          })
        );
      } catch {
        this.topics = [];
      } finally {
        this.loading = false;
      }
    }

    <template>
      {{#if this.shouldShow}}
        {{#unless this.loading}}
          {{#if this.topics.length}}
            <div class="popular-topics-container">
              <h3 class="popular-topics-title">
                <a href="/top?period={{settings.period}}">{{settings.widget_title}}</a>
              </h3>
              <div class="latest-topic-list">
                {{#each this.topics as |topic|}}
                  <LatestTopicListItem @topic={{topic}} />
                {{/each}}
              </div>
            </div>
          {{/if}}
        {{/unless}}
      {{/if}}
    </template>
  });
});
