import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()



const createSocket = (topicId) => {
    let channel = socket.channel(`comments:${topicId}`);

    channel.join()
      .receive("ok", resp => { 
        renderComments(resp.comments)
       })
      .receive("error", resp => { console.log("Unable to join", resp);
       });

    channel.on(`comments:${topicId}:new`, renderComment);

    document.querySelector('button').addEventListener('click', () => {
        const content = document.querySelector('textarea').value;
        if (content) {
          channel.push('comment:add', {content: content});
        }
    /* Get the elements whit the css selector '.userinputs' */
    var elements = document.querySelectorAll(".materialize-textarea");

    /* Iterate the elements array */
    for(var element of elements) {
        element.value = "";
    }
    });
};

function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
  });

  document.querySelector('.collection').innerHTML = renderedComments.join('');
}

function renderComment(event) {

  const renderedComment = commentTemplate(event.comment);

  document.querySelector('.collection').innerHTML += renderedComment;
}

function commentTemplate(comment) {
  let email = 'Anonymous';
  if (comment.user) {
    email = comment.user.email;
  }
  let date_time = comment.inserted_at;
  let date = date_time.slice(8, 10) + "." + date_time.slice(5, 7) + "." + date_time.slice(0, 4);
  let time = date_time.slice(11, 13) + ":" + date_time.slice(14, 16);
  return `
    <li class = "collection-item">
          ${comment.content}
          <div class = "secondary-content comment-item">
            ${email}
            <br>
            ${"Added " + date + " " + time}
          </div>
    </li>
  `;
}

window.createSocket = createSocket;
