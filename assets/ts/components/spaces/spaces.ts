import './spaces.css';
import Component from '../component';
import { channelOn, channelPush, getInitConfig } from '../../util/socket';
import { getUserId } from '../../util/user';

export default class SpacesComponent extends Component {
  renderSpace(spaceName: string) {
    document.getElementById(`spaces-tbody-${this.COMPONENT_ID}`).innerHTML += `
      <tr>
        <td class="space-title">
          ${spaceName}
        </td>
        <td>
          <a href="/s/${spaceName
            .toLowerCase()
            .replace(
              /\s/g,
              '-'
            )}"><button class="btn space-join-btn">Join</button></a>
        </td>
      </tr>
    `;
  }

  render(selector: string) {
    document.querySelector(selector).innerHTML = `
      <div class="card bd-light mb-3" id="${this.COMPONENT_ID}">
        <div class="card-header">
          <h3 class="card-title spaces-header">Spaces</h3>
          <button class="btn btn-primary" data-toggle="modal" data-target="#${this.id(
            'new-space-model'
          )}" style="float: right" id="btn-new-space-${this.COMPONENT_ID}">
            New Space
          </button>
        </div>
        <div class="card-body spaces-card-body">
          <table class="table">
            <tbody id="${this.id('spaces-tbody')}">
            </tbody>
          </table>
        </div>
      </div>

      <div class="modal fade" id="${this.id('new-space-model')}">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">New Space</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <input type="text" id="${this.id(
                'tb-new-space-name'
              )}" class="form-control" placeholder="Space Name" />
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-primary" id="${this.id(
                'btn-create-space'
              )}">Create Space</button>
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
    `;

    document
      .getElementById(this.id('btn-create-space'))
      .addEventListener('click', (e) => {
        e.preventDefault();
        const input = document.getElementById(
          this.id('tb-new-space-name')
        ) as HTMLInputElement;

        channelPush('space:post', { name: input.value, user_id: getUserId() });
        document.location.reload();
        input.value = '';
      });

    channelOn('space:new', (space) => {
      this.renderSpace(space.name);
    });

    console.log(getInitConfig());
    (getInitConfig() as any).spaces.forEach(this.renderSpace.bind(this));
  }
}
