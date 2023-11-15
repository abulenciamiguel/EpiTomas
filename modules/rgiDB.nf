process rgiDB {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "Downloading the latest CARD database"



	output:
	path "data", emit: database


	script:
	"""
	wget --no-check-certificate https://card.mcmaster.ca/latest/data


	"""
}

