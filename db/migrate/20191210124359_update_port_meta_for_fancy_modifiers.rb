class UpdatePortMetaForFancyModifiers < ActiveRecord::Migration[5.2]
  def up
    Adventure.find_each do |adventure|
      port_meta = adventure.content["portMeta"]

      next if !port_meta.present?

      port_meta.each do |port_id, old_meta|
        new_meta = {}

        if old_meta["addsModifier"].present?
          new_meta["itemChanges"] = [
            {
              name: old_meta["addsModifier"],
              action: "add"
            }
          ]
        end

        if old_meta["showIf"].present?
          new_meta["showIfItems"] = [
            {
              name: old_meta["showIf"],
              hasIt: true
            }
          ]
        end

        if old_meta["showUnless"].present?
          new_meta["showIfItems"] = [
            {
              name: old_meta["showUnless"],
              hasIt: false
            }
          ]
        end

        port_meta[port_id] = new_meta
      end

      adventure.content["portMeta"] = port_meta
      adventure.save!
    end
  end

  def down
    # https://www.youtube.com/watch?v=AjGXn249Fc0
  end
end
