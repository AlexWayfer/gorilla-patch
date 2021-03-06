# frozen_string_literal: true

require_relative 'deep_dup'

module GorillaPatch
	## Adding deep_merge method
	module DeepMerge
		refine Hash do
			def deep_merge!(other_hash, &block)
				other_hash.each do |other_key, other_value|
					self_value = self[other_key]

					deep_value_merge!(other_key, self_value, other_value, &block)
				end

				self
			end

			using GorillaPatch::DeepDup

			def deep_merge(other_hash, &block)
				deep_dup.deep_merge!(other_hash, &block)
			end

			private

			def deep_value_merge!(other_key, self_value, other_value, &block)
				self[other_key] =
					if self_value.is_a?(Hash) && other_value.is_a?(Hash)
						self_value.deep_merge!(other_value, &block)
					elsif block && key?(other_key)
						yield(other_key, self_value, other_value)
					else
						other_value
					end
			end
		end
	end
end
