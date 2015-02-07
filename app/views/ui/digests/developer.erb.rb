<% content_for :developer do %>

<h1>Developer digest view2</h1>

<table border='1'>
  <tr>
    <th>Key</th>
<th>Menu Name High</th>
    <th>Henu Index High</th>
<th>Menu Name Med</th>
    <th>Henu Index Med</th>
<th>Menu Name Low</th>
    <th>Henu Index Low</th>
<th>Data Length</th>
  </tr>

<% @digests.each do |digest| %>
      <tr>
<td><%= digest.key %></td>

        <td><%= digest.menu_name_high %></td>
<td><%= digest.menu_index_high %></td>

        <td><%= digest.menu_name_med %></td>
<td><%= digest.menu_index_med %></td>

        <td><%= digest.menu_name_low %></td>
<td><%= digest.menu_index_low %></td>

        <td><%= digest.data_length %></td>

<td><%= link_to 'Show', digest %></td>
        <td><%= link_to 'Edit', edit_digest_path(digest) %></td>
        <td><%= link_to 'Destroy', digest, method: :delete, data: { confirm: 'Are you sure?' } %></td>
</tr>
  <% end %>
</table>

<br />

<%= link_to 'New Digest', new_digest_path %>

<% end %>

<% content_for :user_header do %>
<header id="header" class="row">
  <div class="large-12 columns">
    <hr/>
<div class="row">
<div class="large-6 columns">
<ul class="inline-list right">


<h1>User Header</h1>

          <table border='1'>
            <% @digests.each do |digest| %>
                <tr>
                  <td><%= digest.key %></td>

<td><%= digest.menu_name_high %></td>
                  <td><%= digest.menu_index_high %></td>

<td><%= digest.menu_name_med %></td>
                  <td><%= digest.menu_index_med %></td>

<td><%= digest.menu_name_low %></td>
                  <td><%= digest.menu_index_low %></td>


<td><%= link_to 'Show', digest %></td>
                 </tr>
            <% end %>
          </table>

          <br />


          <li>authorization_ui_rules_path, :remote => true</li>
          <li>authorization_ui_user_rule_path, :remote => true</li>
<li>authorization_ui_ruleset_path, :remote => true</li>
          <li>authorization_ui_ruleset_rule_path, :remote => true</li>
<li>authorization_ui_user_ruleset_path, :remote => true</li>
          <li>authorization_ui_transition_path, :remote => true</li>




</ul>
      </div>
</div>
  </div>
</header>
<% end %>